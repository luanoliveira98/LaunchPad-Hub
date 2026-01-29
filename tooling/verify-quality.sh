#!/bin/bash

# Define o diretório de trabalho: 
# Defines the working directory:
# 1. The passed argument OR 2. The directory where the terminal is opened
WORKING_DIR=${1:-"."}

echo "🧪 [QUALITY CHECK] Checking directory: $WORKING_DIR"

# Enters the folder to ensure npm finds the correct package.json
cd "$WORKING_DIR" || { echo "❌ Directory not found"; exit 1; }

if [ ! -f "package.json" ]; then
  echo "❌ No package.json found in $WORKING_DIR. Skipping tests."
  exit 0
fi

echo "📊 Running tests and coverage in $(basename "$PWD")..."

npm run test:cov || exit 1
npm run test:e2e || exit 1

echo "✅ Quality check passed for $(basename "$PWD")!"