#!/bin/bash

TARGET_DIR=$1
echo "🧪 Running quality checks for: $(basename "$TARGET_DIR")..."

cd "$TARGET_DIR" || exit 1

# 1. Run Unit Tests with Coverage
echo "📊 Checking unit tests and coverage..."
if ! pnpm run test:cov; then
  echo "❌ [ERROR] Unit tests failed or coverage threshold not met."
  exit 1
fi

# 2. Run E2E Tests
echo "🏁 Running E2E tests..."
if ! pnpm run test:e2e; then
  echo "❌ [ERROR] E2E tests failed."
  exit 1
fi

echo "✅ All checks passed! Proceeding with commit..."
exit 0