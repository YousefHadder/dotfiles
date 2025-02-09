#!/usr/bin/env ruby

# This script generates a JWT token for a given audience using the
# certificate and private key issued by the vault-pki-delivery-s2s
# PKI backend. The JWT token is signed using the private key and
# contains the certificate in the x5c header.
#
# This script is meant for the ops shell.
# $ ssh gh-ops-shell
# $ # create a ops-shell-gen-jwt.rb file with the contents of this script.
# $ . vault-login
# $ # Audience examples: heaven, devportal-api
# $ /data/github/current/bin/safe-ruby ops-shell-gen-jwt.rb <audience>

require "jwt"
require "openssl"
require "optparse"
require "json"
require "uri"
require "net/http"
require "fileutils"
require "securerandom"

options = {issuer: "#{`hostname`.strip}"}

if ARGV.empty?
  puts "Usage: ops-shell-gen-jwt.rb AUDIENCE [options]"
  exit
end

audience = ARGV[0]

OptionParser.new do |opts|
  opts.banner = "Usage: ops-shell-gen-jwt.rb AUDIENCE [options]"

  opts.on("-iISSUER", "--issuer=ISSUER", "Specify the JWT issuer (default: `hostname`)") do |i|
    options[:issuer] = i
  end
end.parse!


def extract_cn_from_certificate(cert_pem)
  certificate = OpenSSL::X509::Certificate.new(cert_pem)
  subject = certificate.subject
  cn_entry = subject.to_a.find { |name, _, _| name == 'CN' }
  cn = cn_entry[1] if cn_entry
  cn
end

def generate_jwt(aud:, iss:, leaf_pem:, key_pem:)
  cn = extract_cn_from_certificate(leaf_pem)
  key = OpenSSL::PKey::RSA.new(key_pem)

  certificate = OpenSSL::X509::Certificate.new(leaf_pem)

  kid = OpenSSL::Digest::SHA256.new(certificate.to_der).to_s

  cert_der = Base64.strict_encode64(certificate.to_der)

  headers = {
    "typ" => "JWT",
    "alg" => "RS256",
    "kid" => kid,
    "x5c" => [cert_der],
  }

  payload = {
    sub: cn,
    user: ENV["LOGNAME"],
    exp: Time.now.to_i + 59 * 60 * 4,
    iat: Time.now.to_i,
    aud: aud,
    iss: iss,
    jti: SecureRandom.uuid,
    jid: SecureRandom.uuid
  }

  # Generate the JWT
  token = JWT.encode(payload, key, 'RS256', headers)
  token
end

cn = "user-#{ENV["LOGNAME"]}"
output = IO.popen([{ "VAULT_ADDR" => "https://vault.service.github.net:8200" },
                 "vault", "write", "pki-root-delivery-s2s/issue/identity-certificate",
                 "common_name=#{cn}", "--format=json"]) { |io| io.read }
cert_data = JSON.parse(output)['data']

timestamp = Time.now.utc.strftime('%Y-%m-%d-%H-%M-%S')
save_dir = "tmp/#{timestamp}-signing-material"

FileUtils.mkdir_p(save_dir)

leaf = cert_data['certificate']
ca = cert_data['issuing_ca']

blob = JSON.pretty_generate(cert_data)

File.open("#{save_dir}/signing-material.json", "w:UTF-8") do |f|
  f.puts(blob)
end

File.open("#{save_dir}/leaf.pem",  "w:UTF-8") do |f|
  f.puts(leaf)
end

File.open("#{save_dir}/certificate-authority.pem",  "w:UTF-8") do |f|
  f.puts(ca)
end

token = generate_jwt(aud: audience,
                     iss: options[:issuer],
                     leaf_pem: cert_data["certificate"],
                     key_pem: cert_data["private_key"])

File.open("#{save_dir}/token.jwt",  "w:UTF-8") do |f|
  f.puts(token)
end

puts token

