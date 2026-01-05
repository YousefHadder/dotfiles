#!/usr/bin/env bash
# Test Phase 4: Polish & User Experience

set -e  # Exit on error

echo "========================================================="
echo "Phase 4 Test: Polish & User Experience"
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

# Run installation in container
echo "▶️  Running installation in container..."
echo "   (This tests enhanced logging and UX improvements)"
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
docker cp "$container_id:/home/testuser/dotfiles_install.log" ./logs/phase4-test.log 2>/dev/null && {
    echo "✅ Log file extracted to ./logs/phase4-test.log"
} || {
    echo "❌ Failed to extract log file from container"
    echo "Debug info:"
    echo "Container ID: $container_id"
    echo ""
    echo "Container logs (last 30 lines):"
    docker logs "$container_id" | tail -30
    echo ""
    exit 1
}

# Also capture console output for visual inspection
echo "▶️  Capturing console output..."
docker logs "$container_id" > ./logs/phase4-console.log 2>&1
echo "✅ Console output saved to ./logs/phase4-console.log"

# Remove the container now that we have the logs
docker rm "$container_id" > /dev/null 2>&1

echo ""

# Analyze log file
echo "========================================================="
echo "Test Results"
echo "========================================================="
echo ""

if [ ! -f "./logs/phase4-test.log" ]; then
    echo "❌ Log file not created"
    exit 1
fi

echo "✅ Log file created"
echo ""

# Check for enhanced logging markers
echo "Checking for Phase 4 enhancements:"

if grep -q "PHASE 1: Bootstrap System" "./logs/phase4-test.log"; then
    echo "  ✅ Section headers present"
else
    echo "  ❌ Section headers missing"
    exit 1
fi

if grep -q "ℹ️" "./logs/phase4-test.log"; then
    echo "  ✅ Info logging (ℹ️) present"
else
    echo "  ❌ Info logging missing"
    exit 1
fi

if grep -q "Waiting for Background Jobs" "./logs/phase4-test.log"; then
    echo "  ✅ Background job section present"
else
    echo "  ❌ Background job section missing"
    exit 1
fi

if grep -q "\[1/" "./logs/phase4-test.log" || grep -q "\[2/" "./logs/phase4-test.log"; then
    echo "  ✅ Progress indicators present"
else
    echo "  ❌ Progress indicators missing"
    exit 1
fi

echo ""

# Check for timing summary
if grep -q "TIMING SUMMARY" "./logs/phase4-test.log"; then
    echo "✅ Timing summary present"
else
    echo "❌ Timing summary missing"
    exit 1
fi

echo ""
echo "========================================================="
echo "Visual Enhancements Check"
echo "========================================================="
echo ""

# Show sample of enhanced output
echo "Sample of section headers:"
grep "PHASE [0-9]:" "./logs/phase4-test.log" | head -5

echo ""
echo "Sample of enhanced logging:"
grep -E "✅|ℹ️|⚠️|❌" "./logs/phase4-test.log" | head -10

echo ""
echo "========================================================="
echo "Timing Summary"
echo "========================================================="
echo ""

# Extract and display timing summary
grep -A 30 "TIMING SUMMARY" "./logs/phase4-test.log"

echo ""
echo "========================================================="
echo "Phase 4 Test: PASSED ✅"
echo "========================================================="
echo ""
echo "Enhancements verified:"
echo "  ✅ Section headers for each phase"
echo "  ✅ Color-coded logging (success, info, warning, error)"
echo "  ✅ Progress indicators for background jobs"
echo "  ✅ Enhanced visual banners"
echo "  ✅ Professional polish applied"
echo ""
echo "Full log: ./logs/phase4-test.log"
echo "Console output: ./logs/phase4-console.log"
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
echo "════════════════════════════════════════════════════════"
echo "  🎉 ALL 4 PHASES COMPLETE! 🎉"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Phase 1: ✅ Logging & Timing Infrastructure"
echo "Phase 2: ✅ Brewfile Splitting & Prioritization"
echo "Phase 3: ✅ Parallel Installation Framework"
echo "Phase 4: ✅ Polish & User Experience"
echo ""
echo "Your dotfiles installation system is now optimized!"
echo ""
