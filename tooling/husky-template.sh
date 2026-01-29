#!/bin/bash
# tooling/husky-template.sh

TARGET_DIR=$1
TEMPLATE_NAME=$(basename "$TARGET_DIR")

echo "🐶 Setting up Husky for template: $TEMPLATE_NAME..."

cd "$TARGET_DIR" || exit

# Initialize Husky in the target project
npx husky install
mkdir -p .husky

# Create the commit-msg hook with the dynamic template name enforcement
cat <<EOF > .husky/commit-msg
#!/bin/sh
. "\$(dirname "\$0")/_/husky.sh"

# Capture the commit message
commit_msg=\$(cat \$1)

# Pattern: type[template-name]: message
pattern="^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)\[$TEMPLATE_NAME\]: .+"

if ! echo "\$commit_msg" | grep -qE "\$pattern"; then
  echo "\n❌ [COMMIT REJECTED]"
  echo "Format expected: type[$TEMPLATE_NAME]: message"
  echo "Example: feat[$TEMPLATE_NAME]: add user authentication\n"
  echo "Allowed types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert\n"
  exit 1
fi

npx --no -- commitlint --edit "\$1"
EOF

chmod +x .husky/commit-msg