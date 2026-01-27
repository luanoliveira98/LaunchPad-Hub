#!/bin/bash

# 1. Starts Husky
npx husky install

# 2. Commit Message Hook (Conventional Commits)
npx husky add .husky/commit-msg 'npx --no-install commitlint --edit "$1"'

# 3. Pre-commit Hook (Lint + Tests on changed files)
npx husky add .husky/pre-commit "npx lint-staged"

echo "🐶 Husky hooks configured successfully!"