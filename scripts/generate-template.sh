#!/bin/bash

# LaunchPad Hub - Manual Template Creator
ROOT_DIR=$(pwd)
TEMPLATES_BASE_DIR="templates"
export ROOT_DIR=$(pwd)

# --- Reusable Menu Function ---
function gui_select() {
    local title=$1; shift
    local options=("$@")
    local selected=0
    local num_options=${#options[@]}
    function print_menu() {
        echo -e "\e[1;33m$title\e[0m"
        for i in "${!options[@]}"; do
            if [ "$i" -eq "$selected" ]; then echo -e "\e[36m  ❯ ${options[$i]}\e[0m"; else echo -e "    ${options[$i]}"; fi
        done
    }
    function clear_menu() { local lines=$((num_options + 1)); for ((i=0; i<lines; i++)); do echo -ne "\033[F\033[K"; done; }
    print_menu
    while true; do
        read -rsn3 key
        case "$key" in
            $'\x1b[A') ((selected--)); [ "$selected" -lt 0 ] && selected=$((num_options - 1)) ;;
            $'\x1b[B') ((selected++)); [ "$selected" -ge "$num_options" ] && selected=0 ;;
            "") clear_menu; return "$selected" ;;
        esac
        clear_menu; print_menu
    done
}
export -f gui_select

# 1. Select or Create Category
mkdir -p "$TEMPLATES_BASE_DIR"
EXISTING_CATEGORIES=($(ls -d $TEMPLATES_BASE_DIR/*/ 2>/dev/null | xargs -n 1 basename))
CATEGORIES_OPTIONS=("${EXISTING_CATEGORIES[@]}" "[ Create New Category ]")

gui_select "📁 Select Category:" "${CATEGORIES_OPTIONS[@]}"
SELECTED_INDEX=$?

if [ "$SELECTED_INDEX" -eq "$((${#CATEGORIES_OPTIONS[@]} - 1))" ]; then
    read -p "✨ Enter new category name: " SELECTED_CATEGORY
else
    SELECTED_CATEGORY=${CATEGORIES_OPTIONS[$SELECTED_INDEX]}
fi

# 2. Template Name
read -p "📄 Enter Template Name: " TEMPLATE_NAME
TARGET_DIR="$ROOT_DIR/$TEMPLATES_BASE_DIR/$SELECTED_CATEGORY/$TEMPLATE_NAME"

echo -e "\n🏗️ Creating template structure at $TARGET_DIR..."

# 3. Inject Shared Configs
if [ -d "$ROOT_DIR/tooling/shared-configs" ]; then
    echo "🛠️  Injecting shared-configs..."
    cp -rf "$ROOT_DIR/tooling/shared-configs/." "$TARGET_DIR/"
fi

# 4. Create Generic package.json
cat <<EOF > "$TARGET_DIR/package.json"
{
  "name": "$TEMPLATE_NAME",
  "version": "0.0.1",
  "description": "Enterprise Architecture template",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "dependencies": {},
  "devDependencies": {}
}
EOF

# 5. Cleanup & Finish
cd "$TARGET_DIR" || exit
echo "# $TEMPLATE_NAME Template" > README.md

echo -e "\n✅ Success! Template '$TEMPLATE_NAME' is ready."
echo "👉 You can now add your specific dependencies and code."