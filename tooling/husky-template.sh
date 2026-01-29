#!/bin/bash
# tooling/husky-template.sh

TARGET_DIR=$1
TEMPLATE_NAME=$(basename "$TARGET_DIR")
HUB_ROOT=$(pwd)

echo "🐶 Setting up Husky for $TEMPLATE_NAME..."

cd "$TARGET_DIR" || exit
npx husky install
mkdir -p .husky

# --- Pre-commit hook: Tests and Coverage ---
cat <<EOF > .husky/pre-commit
#!/bin/sh
. "\$(dirname "\$0")/_/husky.sh"

# Call the shared verification script
bash "$HUB_ROOT/tooling/verify-test-coverage.sh" "."
EOF

# --- Commit-msg hook: Pattern enforcement ---
cat <<EOF > .husky/commit-msg
#!/bin/sh
. "\$(dirname "\$0")/_/husky.sh"

commit_msg=\$(cat \$1)
pattern="^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)\[$TEMPLATE_NAME\]: .+"

if ! echo "\$commit_msg" | grep -qE "\$pattern"; then
  echo "\n❌ [COMMIT REJECTED] Format: type[$TEMPLATE_NAME]: message"
  exit 1
fi

npx --no -- commitlint --edit "\$1"
EOF

chmod +x .husky/pre-commit
chmod +x .husky/commit-msg