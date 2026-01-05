#!/usr/bin/env bash
# Test Phase 1: Logging and Timing Infrastructure

set -e  # Exit on error

echo "========================================================="
echo "Phase 1 Test: Logging & Timing Infrastructure"
echo "========================================================="
echo ""

# Navigate to dotfiles directory
cd "$(dirname "$0")"

# Clean up any previous test containers
echo "🧹 Cleaning up any previous test runs..."
docker-compose -f docker/docker-compose.test.yml down --volumes 2>/dev/null || true
echo ""

# Backup full Brewfile and use test Brewfile for faster testing
echo "📦 Setting up minimal Brewfile for testing..."
if [ -f Brewfile ]; then
    cp Brewfile Brewfile.backup
    cp Brewfile.test Brewfile
    echo "✅ Using minimal Brewfile (4 packages instead of 26)"
fi
echo ""

# Build Docker test image
echo "▶️  Building Docker test image..."
docker-compose -f docker/docker-compose.test.yml build --quiet

echo "✅ Docker image built"
echo ""

# Run installation in container (without --rm so we can extract files)
echo "▶️  Running installation in container..."
echo "   (This should take 2-3 minutes with minimal Brewfile)"
echo ""

# Start container and run installation
container_id=$(docker-compose -f docker/docker-compose.test.yml run --no-deps -d dotfiles-test ./install.sh)

# Wait for container to finish
echo "⏳ Waiting for installation to complete..."
docker wait "$container_id" > /dev/null

echo "✅ Installation completed"
echo ""

# Copy log file from container
echo "▶️  Extracting log file..."
docker cp "$container_id:/home/testuser/dotfiles_install.log" ./logs/phase1-test.log 2>/dev/null && {
    echo "✅ Log file extracted to ./logs/phase1-test.log"
} || {
    echo "❌ Failed to extract log file from container"
    echo "Debug info:"
    echo "Container ID: $container_id"
    echo ""
    echo "Container logs (last 20 lines):"
    docker logs "$container_id" | tail -20
    echo ""
    echo "Trying to list files in container home directory:"
    docker exec "$container_id" ls -la /home/testuser/ 2>&1 || echo "Could not list files"
    exit 1
}

# Remove the container now that we have the log
docker rm "$container_id" > /dev/null 2>&1

echo ""

# Analyze log file
echo "========================================================="
echo "Test Results"
echo "========================================================="
echo ""

if [ ! -f "./logs/phase1-test.log" ]; then
    echo "❌ Log file not created"
    exit 1
fi

echo "✅ Log file created"
echo ""

# Check for timing summary
if grep -q "TIMING SUMMARY" "./logs/phase1-test.log"; then
    echo "✅ Timing summary present"
else
    echo "❌ Timing summary missing"
    exit 1
fi
echo ""

# Check for all phases
echo "Checking for all installation phases:"
phases=(
    "Bootstrap phase"
    "Homebrew installation"
    "Package installation"
    "Language tools installation"
    "Scripts copy"
    "Symlink creation"
)

missing_phases=()
for phase in "${phases[@]}"; do
    if grep -q "$phase" "./logs/phase1-test.log"; then
        echo "  ✅ $phase"
    else
        echo "  ❌ $phase"
        missing_phases+=("$phase")
    fi
done

if [ ${#missing_phases[@]} -gt 0 ]; then
    echo ""
    echo "❌ Missing phases: ${missing_phases[*]}"
    exit 1
fi

echo ""
echo "========================================================="
echo "Timing Summary from Installation"
echo "========================================================="
echo ""

# Extract and display timing summary
grep -A 30 "TIMING SUMMARY" "./logs/phase1-test.log"

echo ""
echo "========================================================="
echo "Performance Insights"
echo "========================================================="
echo ""

# Show slow operations if any
if grep -q "Operations taking >60s" "./logs/phase1-test.log"; then
    grep -A 10 "Operations taking >60s" "./logs/phase1-test.log"
    echo ""
fi

if grep -q "Operations taking 10-60s" "./logs/phase1-test.log"; then
    grep -A 10 "Operations taking 10-60s" "./logs/phase1-test.log"
    echo ""
fi

echo "========================================================="
echo "Phase 1 Test: PASSED ✅"
echo "========================================================="
echo ""
echo "Next steps:"
echo "  1. Review the timing data in logs/phase1-test.log"
echo "  2. Verify all expected phases are logged"
echo "  3. Check that no errors occurred during installation"
echo ""
echo "Full log: ./logs/phase1-test.log"
echo ""

# Cleanup
echo "🧹 Cleaning up Docker containers..."
docker-compose -f docker/docker-compose.test.yml down --volumes

# Restore original Brewfile
if [ -f Brewfile.backup ]; then
    mv Brewfile.backup Brewfile
    echo "✅ Restored original Brewfile"
fi

echo "✅ Cleanup complete"
echo ""
echo "Phase 1 implementation is ready for review!"
