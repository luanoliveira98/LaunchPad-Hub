#!/bin/bash

TARGET_DIR=$1
TEMPLATE_NAME=$(basename "$TARGET_DIR")
HUB_ROOT=$(pwd)

cd "$TARGET_DIR" || exit

# Starts Husky
if [ -d ".git" ] || [ -d "../.git" ]; then
    npx husky install
else
    echo "🔗 Linking Husky to Hub root Git..."
    cd "$HUB_ROOT" && npx husky install "$TARGET_DIR/.husky"
    cd "$TARGET_DIR" || exit
fi

# Configuring pre-commit to run tests
cat <<EOF > .husky/pre-commit
#!/bin/sh
. "\$(dirname "\$0")/_/husky.sh"
bash "$HUB_ROOT/tooling/verify-test-coverage.sh" "."
EOF

# Configuring commit-msg to enforce commit message format type[template]: message
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