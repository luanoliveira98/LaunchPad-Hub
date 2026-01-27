#!/bin/bash

# LaunchPad Hub - Dynamic Project Generator
ROOT_DIR=$(pwd)
TEMPLATES_BASE_DIR="templates"

# --- Reusable Menu Function ---
function gui_select() {
    local title=$1
    shift
    local options=("$@")
    local selected=0

    local num_options=${#options[@]}

    function print_menu() {
        echo -e "\e[1;33m$title\e[0m"
        for i in "${!options[@]}"; do
            if [ "$i" -eq "$selected" ]; then
                echo -e "\e[36m  ❯ ${options[$i]}\e[0m"
            else
                echo -e "    ${options[$i]}"
            fi
        done
    }

    function clear_menu() {
        local lines_to_clear=$((num_options + 1))
        for ((i=0; i<lines_to_clear; i++)); do
            echo -ne "\033[F\033[K"
        done
    }

    print_menu
    while true; do
        read -rsn3 key
        case "$key" in
            $'\x1b[A') ((selected--)); [ "$selected" -lt 0 ] && selected=$((${#options[@]} - 1)) ;;
            $'\x1b[B') ((selected++)); [ "$selected" -ge "${#options[@]}" ] && selected=0 ;;
            "") clear_menu; return "$selected" ;;
        esac
        clear_menu
        print_menu
    done
}

# 1. Select Category
CATEGORIES=($(ls -d $TEMPLATES_BASE_DIR/*/ | xargs -n 1 basename))
gui_select "📁 Select a Category:" "${CATEGORIES[@]}"
SELECTED_CAT_INDEX=$?
SELECTED_CATEGORY=${CATEGORIES[$SELECTED_CAT_INDEX]}

# 2. Select Template
TEMPLATES=($(ls -d $TEMPLATES_BASE_DIR/$SELECTED_CATEGORY/*/ | xargs -n 1 basename))
gui_select "📄 Select a Template:" "${TEMPLATES[@]}"
SELECTED_TEMP_INDEX=$?
SELECTED_TEMPLATE=${TEMPLATES[$SELECTED_TEMP_INDEX]}

TEMPLATE_PATH="$TEMPLATES_BASE_DIR/$SELECTED_CATEGORY/$SELECTED_TEMPLATE"

# 3. Project Name
echo -e "📦 Project Selected: \e[32m$SELECTED_TEMPLATE\e[0m"
read -p "✨ Enter the name for your new project: " PROJECT_NAME

if [ -z "$PROJECT_NAME" ]; then
    echo "❌ Project name cannot be empty."
    exit 1
fi

# 4. Select Package Manager
PKG_OPTIONS=("npm" "yarn" "pnpm")
gui_select "📦 Select your preferred package manager:" "${PKG_OPTIONS[@]}"
SELECTED_PKG_INDEX=$?
PKG_MANAGER=${PKG_OPTIONS[$SELECTED_PKG_INDEX]}

# --- Commands Setting ---
case $PKG_MANAGER in
    "npm")  INSTALL_CMD="npm install" ;;
    "yarn") INSTALL_CMD="yarn install" ;;
    "pnpm") INSTALL_CMD="pnpm install" ;;
esac

echo "🚀 LaunchPad: Generating '$PROJECT_NAME' from '$SELECTED_TEMPLATE'..."

# --- Scaffolding Logic ---
mkdir -p "$PROJECT_NAME"
tar --exclude='node_modules' --exclude='dist' --exclude='.husky' \
    --exclude='*-lock.json' --exclude='*.lock' --exclude='pnpm-lock.yaml' \
    -cf - -C "$TEMPLATE_PATH" . | tar -xf - -C "$PROJECT_NAME"

cp -r tooling/shared-configs/. "$PROJECT_NAME/"

cd "$PROJECT_NAME"
git init > /dev/null

echo "🐶 Initializing Husky and Git Hooks..."
chmod +x "$ROOT_DIR/tooling/husky-template.sh"
source "$ROOT_DIR/tooling/husky-template.sh"

sed -i.bak "s/\"name\": \".*\"/\"name\": \"$PROJECT_NAME\"/" package.json && rm package.json.bak

echo "🚚 Running $PKG_MANAGER install..."
eval "$INSTALL_CMD"

echo -e "\n✅ Success! Project '$PROJECT_NAME' is ready."