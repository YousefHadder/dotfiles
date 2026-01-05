#!/usr/bin/env bash
# Test Phase 3: Parallel Installation Framework

set -e  # Exit on error

echo "========================================================="
echo "Phase 3 Test: Parallel Installation Framework"
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
echo "   (This tests parallel installation framework)"
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
docker cp "$container_id:/home/testuser/dotfiles_install.log" ./logs/phase3-test.log 2>/dev/null && {
    echo "✅ Log file extracted to ./logs/phase3-test.log"
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

# Remove the container now that we have the log
docker rm "$container_id" > /dev/null 2>&1

echo ""

# Analyze log file
echo "========================================================="
echo "Test Results"
echo "========================================================="
echo ""

if [ ! -f "./logs/phase3-test.log" ]; then
    echo "❌ Log file not created"
    exit 1
fi

echo "✅ Log file created"
echo ""

# Check for parallel installation markers
if grep -q "background" "./logs/phase3-test.log"; then
    echo "✅ Background installation present"
else
    echo "❌ Background installation markers missing"
    exit 1
fi

if grep -q "Tracking background job" "./logs/phase3-test.log"; then
    echo "✅ Background job tracking present"
else
    echo "❌ Background job tracking missing"
    exit 1
fi

if grep -q "Waiting for.*background job" "./logs/phase3-test.log"; then
    echo "✅ Background job wait logic present"
else
    echo "❌ Background job wait logic missing"
    exit 1
fi

echo ""

# Check for timing summary
if grep -q "TIMING SUMMARY" "./logs/phase3-test.log"; then
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
    "background"
)

missing_phases=()
for phase in "${phases[@]}"; do
    if grep -q "$phase" "./logs/phase3-test.log"; then
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
grep -A 30 "TIMING SUMMARY" "./logs/phase3-test.log"

echo ""
echo "========================================================="
echo "Background Jobs Analysis"
echo "========================================================="
echo ""

# Show background job tracking
echo "Background jobs initiated:"
grep "background" "./logs/phase3-test.log" | grep -E "(Installing|Tracking)" | head -10

echo ""
echo "Background jobs completion:"
grep "background job" "./logs/phase3-test.log" | grep "Waiting for"

echo ""
echo "========================================================="
echo "Performance Comparison"
echo "========================================================="
echo ""

# Compare Phase 2 vs Phase 3 if Phase 2 log exists
if [ -f "./logs/phase2-test.log" ]; then
    phase2_time=$(grep "Total installation time:" "./logs/phase2-test.log" | grep -oE '[0-9]+s' | head -1 | tr -d 's')
    phase3_time=$(grep "Total installation time:" "./logs/phase3-test.log" | grep -oE '[0-9]+s' | head -1 | tr -d 's')

    if [ -n "$phase2_time" ] && [ -n "$phase3_time" ]; then
        improvement=$((phase2_time - phase3_time))
        percent=$((improvement * 100 / phase2_time))

        echo "Phase 2 (sequential): ${phase2_time}s"
        echo "Phase 3 (parallel):   ${phase3_time}s"
        echo ""

        if [ $improvement -gt 0 ]; then
            echo "🚀 Improvement: ${improvement}s faster (${percent}% reduction)"
        elif [ $improvement -lt 0 ]; then
            echo "⚠️  Slower by $((improvement * -1))s (needs investigation)"
        else
            echo "⚠️  No time difference (unexpected for parallel execution)"
        fi
    fi
else
    echo "Phase 2 log not found - skipping comparison"
fi

echo ""
echo "========================================================="
echo "Phase 3 Test: PASSED ✅"
echo "========================================================="
echo ""
echo "Next steps:"
echo "  1. Review the parallel execution timing"
echo "  2. Verify background jobs completed successfully"
echo "  3. Check performance improvement vs Phase 2"
echo ""
echo "Full log: ./logs/phase3-test.log"
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
echo "Phase 3 implementation is ready for review!"
