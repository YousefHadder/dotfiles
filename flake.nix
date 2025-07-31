{
  description = "Yousef's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
      x86DarwinSystem = "x86_64-darwin";
      
      pkgs = nixpkgs.legacyPackages.${system};
      darwinPkgs = nixpkgs.legacyPackages.${darwinSystem};
      x86DarwinPkgs = nixpkgs.legacyPackages.${x86DarwinSystem};
      
      # Get username from environment variable or default to "user"
      username = builtins.getEnv "USER";
      
      mkHomeConfiguration = system: pkgs: {
        pkgs = pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit system; };
      };
    in {
      homeConfigurations = {
        # Linux configuration
        "${username}@linux" = home-manager.lib.homeManagerConfiguration (mkHomeConfiguration system pkgs);
        
        # macOS Apple Silicon configuration
        "${username}@darwin" = home-manager.lib.homeManagerConfiguration (mkHomeConfiguration darwinSystem darwinPkgs);
        
        # macOS Intel configuration
        "${username}@darwin-x86" = home-manager.lib.homeManagerConfiguration (mkHomeConfiguration x86DarwinSystem x86DarwinPkgs);
      };
    };
}