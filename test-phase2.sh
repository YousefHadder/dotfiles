#!/usr/bin/env bash
# Test Phase 2: Brewfile Splitting & Prioritization

set -e  # Exit on error

echo "========================================================="
echo "Phase 2 Test: Brewfile Splitting & Prioritization"
echo "========================================================="
echo ""

# Navigate to dotfiles directory
cd "$(dirname "$0")"

# Clean up any previous test containers
echo "🧹 Cleaning up any previous test runs..."
docker-compose -f docker/docker-compose.test.yml down --volumes 2>/dev/null || true
echo ""

# Backup and swap Brewfiles for testing
echo "📦 Setting up minimal Brewfiles for testing..."
if [ -f Brewfile.essential ]; then
    cp Brewfile.essential Brewfile.essential.backup
    cp Brewfile.essential.test Brewfile.essential
    echo "✅ Using minimal essential Brewfile (2 packages)"
fi
if [ -f Brewfile.optional ]; then
    cp Brewfile.optional Brewfile.optional.backup
    cp Brewfile.optional.test Brewfile.optional
    echo "✅ Using minimal optional Brewfile (2 packages)"
fi
echo ""

# Build Docker test image
echo "▶️  Building Docker test image..."
docker-compose -f docker/docker-compose.test.yml build --quiet

echo "✅ Docker image built"
echo ""

# Run installation in container (without --rm so we can extract files)
echo "▶️  Running installation in container..."
echo "   (This tests split Brewfile functionality)"
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
docker cp "$container_id:/home/testuser/dotfiles_install.log" ./logs/phase2-test.log 2>/dev/null && {
    echo "✅ Log file extracted to ./logs/phase2-test.log"
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

if [ ! -f "./logs/phase2-test.log" ]; then
    echo "❌ Log file not created"
    exit 1
fi

echo "✅ Log file created"
echo ""

# Check for split package installation
if grep -q "Essential packages" "./logs/phase2-test.log"; then
    echo "✅ Essential packages phase present"
else
    echo "❌ Essential packages phase missing"
    exit 1
fi

if grep -q "Optional packages" "./logs/phase2-test.log"; then
    echo "✅ Optional packages phase present"
else
    echo "❌ Optional packages phase missing"
    exit 1
fi

echo ""

# Check for timing summary
if grep -q "TIMING SUMMARY" "./logs/phase2-test.log"; then
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
    "Essential packages"
    "Optional packages"
    "Language tools installation"
    "Scripts copy"
    "Symlink creation"
)

missing_phases=()
for phase in "${phases[@]}"; do
    if grep -q "$phase" "./logs/phase2-test.log"; then
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
grep -A 30 "TIMING SUMMARY" "./logs/phase2-test.log"

echo ""
echo "========================================================="
echo "Package Installation Breakdown"
echo "========================================================="
echo ""

# Show essential vs optional timing
echo "Essential packages timing:"
grep "Essential packages" "./logs/phase2-test.log" | grep "✅"

echo ""
echo "Optional packages timing:"
grep "Optional packages" "./logs/phase2-test.log" | grep "✅"

echo ""
echo "========================================================="
echo "Phase 2 Test: PASSED ✅"
echo "========================================================="
echo ""
echo "Next steps:"
echo "  1. Review the timing breakdown for essential vs optional packages"
echo "  2. Verify package organization makes sense"
echo "  3. Check that no errors occurred during installation"
echo ""
echo "Full log: ./logs/phase2-test.log"
echo ""

# Cleanup
echo "🧹 Cleaning up Docker containers..."
docker-compose -f docker/docker-compose.test.yml down --volumes

# Restore original Brewfiles
if [ -f Brewfile.essential.backup ]; then
    mv Brewfile.essential.backup Brewfile.essential
    echo "✅ Restored original Brewfile.essential"
fi
if [ -f Brewfile.optional.backup ]; then
    mv Brewfile.optional.backup Brewfile.optional
    echo "✅ Restored original Brewfile.optional"
fi

echo "✅ Cleanup complete"
echo ""
echo "Phase 2 implementation is ready for review!"
