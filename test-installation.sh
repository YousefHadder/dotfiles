#!/usr/bin/env bash
# End-to-end test of the optimized installation system in Docker
# This script tests the complete installation from scratch

set -e  # Exit on error

echo "========================================================="
echo "End-to-End Installation Test"
echo "========================================================="
echo ""
echo "This test will:"
echo "  1. Build a clean Ubuntu 22.04 Docker image"
echo "  2. Run the complete installation system"
echo "  3. Verify all packages were installed"
echo "  4. Show timing and performance metrics"
echo ""

# Navigate to dotfiles directory
cd "$(dirname "$0")"

# Clean up any previous containers
echo "🧹 Cleaning up previous test runs..."
docker stop dotfiles-e2e-test 2>/dev/null || true
docker rm dotfiles-e2e-test 2>/dev/null || true
echo ""

# Build test image
echo "▶️  Building Docker test image..."
echo ""

# Create temporary Dockerfile for testing
cat > Dockerfile.e2e <<'EOF'
FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV HOMEBREW_NO_INSTALL_CLEANUP=1
ENV HOMEBREW_NO_ANALYTICS=1

# Install basic dependencies including zsh
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    build-essential \
    file \
    procps \
    zsh \
    && rm -rf /var/lib/apt/lists/*

# Create test user with sudo access
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER testuser
WORKDIR /home/testuser

# Copy dotfiles
COPY --chown=testuser:testuser . /home/testuser/dotfiles
WORKDIR /home/testuser/dotfiles

CMD ["./install.sh"]
EOF

docker build -f Dockerfile.e2e -t dotfiles-e2e-test . --quiet

echo "✅ Docker image built"
echo ""

# Run installation
echo "▶️  Running complete installation..."
echo "   (This may take 3-5 minutes depending on your connection)"
echo ""

start_time=$(date +%s)

# Run container and capture output
docker run --name dotfiles-e2e-test dotfiles-e2e-test 2>&1 | tee /tmp/dotfiles-e2e-output.log

end_time=$(date +%s)
duration=$((end_time - start_time))

echo ""
echo "✅ Installation completed in ${duration}s"
echo ""

# Extract log file from container
echo "▶️  Extracting installation log..."
docker cp dotfiles-e2e-test:/home/testuser/dotfiles_install.log ./dotfiles_install.log 2>/dev/null && {
    echo "✅ Log file extracted to ./dotfiles_install.log"
} || {
    echo "⚠️  Could not extract log file (installation may have failed)"
}
echo ""

# Verify installation
echo "========================================================="
echo "Verification"
echo "========================================================="
echo ""

# Check if timing summary exists
if [ -f ./dotfiles_install.log ] && grep -q "TIMING SUMMARY" ./dotfiles_install.log; then
    echo "✅ Timing summary generated"
else
    echo "❌ Timing summary missing"
fi

# Check for key installations
echo ""
echo "Checking installed components:"

# Check zsh
if docker exec dotfiles-e2e-test zsh --version 2>/dev/null; then
    echo "  ✅ zsh installed"
else
    echo "  ❌ zsh not found"
fi

# Check Oh My Zsh
if docker exec dotfiles-e2e-test test -d /home/testuser/.oh-my-zsh 2>/dev/null; then
    echo "  ✅ Oh My Zsh installed"
else
    echo "  ❌ Oh My Zsh not found"
fi

# Check Homebrew
if docker exec dotfiles-e2e-test test -f /home/linuxbrew/.linuxbrew/bin/brew 2>/dev/null; then
    echo "  ✅ Homebrew installed"
else
    echo "  ❌ Homebrew not found"
fi

# Check essential packages
echo ""
echo "Checking essential packages:"
essential_packages=("stow" "fzf" "neovim" "tmux" "ripgrep")
for pkg in "${essential_packages[@]}"; do
    if docker exec dotfiles-e2e-test /home/linuxbrew/.linuxbrew/bin/brew list "$pkg" 2>/dev/null >/dev/null; then
        echo "  ✅ $pkg"
    else
        echo "  ❌ $pkg"
    fi
done

# Check optional packages
echo ""
echo "Checking optional packages (sample):"
optional_packages=("bat" "eza" "fd")
for pkg in "${optional_packages[@]}"; do
    if docker exec dotfiles-e2e-test /home/linuxbrew/.linuxbrew/bin/brew list "$pkg" 2>/dev/null >/dev/null; then
        echo "  ✅ $pkg"
    else
        echo "  ❌ $pkg"
    fi
done

# Check Rust
echo ""
echo "Checking language tools:"
if docker exec dotfiles-e2e-test test -f /home/testuser/.cargo/bin/cargo 2>/dev/null; then
    echo "  ✅ Rust/Cargo installed"
else
    echo "  ⚠️  Rust/Cargo not found (may still be installing in background)"
fi

# Display timing summary
echo ""
echo "========================================================="
echo "Performance Metrics"
echo "========================================================="
echo ""

if [ -f ./dotfiles_install.log ]; then
    echo "Installation timing breakdown:"
    echo ""
    grep -A 20 "TIMING SUMMARY" ./dotfiles_install.log || echo "Timing summary not found in log"
    echo ""

    # Check for parallel execution
    if grep -q "background" ./dotfiles_install.log; then
        echo "✅ Parallel installation detected"
        echo ""
        echo "Background jobs:"
        grep "Tracking background job" ./dotfiles_install.log || echo "No background job tracking found"
    fi
else
    echo "⚠️  Installation log not available"
fi

echo ""
echo "========================================================="
echo "Console Output Analysis"
echo "========================================================="
echo ""

if [ -f /tmp/dotfiles-e2e-output.log ]; then
    # Check for visual enhancements
    if grep -q "DOTFILES INSTALLATION SYSTEM" /tmp/dotfiles-e2e-output.log; then
        echo "✅ Welcome banner displayed"
    fi

    if grep -q "INSTALLATION COMPLETE" /tmp/dotfiles-e2e-output.log; then
        echo "✅ Completion banner displayed"
    fi

    if grep -q "PHASE" /tmp/dotfiles-e2e-output.log; then
        echo "✅ Section headers present"
    fi

    if grep -q "ℹ️\|✅\|⚠️" /tmp/dotfiles-e2e-output.log; then
        echo "✅ Color-coded logging present"
    fi
fi

echo ""
echo "========================================================="
echo "Test Summary"
echo "========================================================="
echo ""

echo "Total installation time: ${duration}s ($((duration / 60))m $((duration % 60))s)"
echo ""
echo "Logs saved to:"
echo "  - Installation log: ./dotfiles_install.log"
echo "  - Console output: /tmp/dotfiles-e2e-output.log"
echo ""
echo "To inspect the container:"
echo "  docker exec -it dotfiles-e2e-test bash"
echo ""
echo "To clean up:"
echo "  docker stop dotfiles-e2e-test && docker rm dotfiles-e2e-test"
echo "  rm Dockerfile.e2e dotfiles_install.log /tmp/dotfiles-e2e-output.log"
echo ""

# Cleanup temporary Dockerfile
rm Dockerfile.e2e

echo "========================================================="
echo "✅ End-to-End Test Complete!"
echo "========================================================="
echo ""
