#!/bin/bash

# LaunchPad Hub - Standardized Project Generator
ROOT_DIR=$(pwd)
TEMPLATES_DIR="$ROOT_DIR/templates"

# --- Reusable Menu Function (Sincronizada) ---
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

# 1. Select Template Category
CATEGORIES=($(ls -d $TEMPLATES_DIR/*/ 2>/dev/null | xargs -n 1 basename))
gui_select "📁 Select Template Category:" "${CATEGORIES[@]}"
SELECTED_CATEGORY=${CATEGORIES[$?]}

# 2. Select Specific Template
TEMPLATES=($(ls -d $TEMPLATES_DIR/$SELECTED_CATEGORY/*/ 2>/dev/null | xargs -n 1 basename))
gui_select "📄 Select Template:" "${TEMPLATES[@]}"
SELECTED_TEMPLATE=${TEMPLATES[$?]}

# 3. Project Name & Isolation Logic
read -p "🚀 Enter the name of your new project: " PROJECT_NAME

# DEFINIÇÃO DO CAMINHO: Um nível acima da raiz do Hub
# Se o Hub está em D:/Dev/LaunchPad-Hub, o projeto irá para D:/Dev/PROJECT_NAME
TARGET_DIR="$ROOT_DIR/../$PROJECT_NAME"

echo -e "\n📦 Generating project at: $TARGET_DIR"

# 4. Clone/Copy Process
if [ -d "$TARGET_DIR" ]; then
    echo "❌ Error: A directory with the name '$PROJECT_NAME' already exists one level above."
    exit 1
fi

cp -r "$TEMPLATES_DIR/$SELECTED_CATEGORY/$SELECTED_TEMPLATE" "$TARGET_DIR"

# 5. Initialize New Git Repository (Safely Isolated)
cd "$TARGET_DIR" || exit
git init
git add .
git commit -m "chore: initial commit from LaunchPad Hub ($SELECTED_TEMPLATE)"

echo -e "\n✅ Success! Project generated safely outside the Hub."
echo "👉 Path: $TARGET_DIR"

# 6. Return to Hub
cd "$ROOT_DIR" || exit