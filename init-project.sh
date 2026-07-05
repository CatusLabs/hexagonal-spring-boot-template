#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# init-project.sh - Initialize a new project from this template
#
# Usage: ./init-project.sh <app-name> <group-id> <org-name>
#
# Example: ./init-project.sh arkivo com.catuslabs.arkivo CatusLabs
#
# This script:
#   1. Replaces all {{PLACEHOLDER}} tokens in file contents
#   2. Renames directories/files containing {{APP_NAME}}
#   3. Creates the proper Java package directory structure
#   4. Removes itself after completion
# ============================================================================

if [ $# -lt 3 ]; then
    echo "Usage: $0 <app-name> <group-id> <org-name>"
    echo ""
    echo "  app-name   - Hyphenated app name (e.g., arkivo, software-center)"
    echo "  group-id   - Maven groupId / Java base package (e.g., com.catuslabs.arkivo)"
    echo "  org-name   - GitHub organization name (e.g., CatusLabs)"
    echo ""
    echo "Example: $0 arkivo com.catuslabs.arkivo CatusLabs"
    exit 1
fi

APP_NAME="$1"
GROUP_ID="$2"
ORG_NAME="$3"

# Derive PascalCase from hyphenated name
# e.g., "software-center" -> "SoftwareCenter"
APP_NAME_PASCAL=$(echo "$APP_NAME" | sed -E 's/(^|-)([a-z])/\U\2/g')

# Derive package path from group-id
# e.g., "com.catuslabs.arkivo" -> "com/catuslabs/arkivo"
BASE_PACKAGE="$GROUP_ID"
BASE_PACKAGE_PATH=$(echo "$GROUP_ID" | tr '.' '/')

echo "==========================================================="
echo " Initializing project"
echo "==========================================================="
echo "  APP_NAME:          $APP_NAME"
echo "  APP_NAME_PASCAL:   $APP_NAME_PASCAL"
echo "  GROUP_ID:          $GROUP_ID"
echo "  BASE_PACKAGE:      $BASE_PACKAGE"
echo "  BASE_PACKAGE_PATH: $BASE_PACKAGE_PATH"
echo "  ORG_NAME:          $ORG_NAME"
echo "==========================================================="
echo ""

# Step 1: Replace placeholders in all text files
echo "[1/4] Replacing placeholders in file contents..."
find . -type f \
    ! -path './.git/*' \
    ! -path './init-project.sh' \
    ! -name '*.jar' \
    ! -name '*.class' \
    -exec grep -l '{{' {} \; | while read -r file; do
    if [ "$(uname)" = "Darwin" ]; then
        sed -i '' \
            -e "s|{{APP_NAME_PASCAL}}|$APP_NAME_PASCAL|g" \
            -e "s|{{APP_NAME}}|$APP_NAME|g" \
            -e "s|{{GROUP_ID}}|$GROUP_ID|g" \
            -e "s|{{BASE_PACKAGE_PATH}}|$BASE_PACKAGE_PATH|g" \
            -e "s|{{BASE_PACKAGE}}|$BASE_PACKAGE|g" \
            -e "s|{{ORG_NAME}}|$ORG_NAME|g" \
            "$file"
    else
        sed -i \
            -e "s|{{APP_NAME_PASCAL}}|$APP_NAME_PASCAL|g" \
            -e "s|{{APP_NAME}}|$APP_NAME|g" \
            -e "s|{{GROUP_ID}}|$GROUP_ID|g" \
            -e "s|{{BASE_PACKAGE_PATH}}|$BASE_PACKAGE_PATH|g" \
            -e "s|{{BASE_PACKAGE}}|$BASE_PACKAGE|g" \
            -e "s|{{ORG_NAME}}|$ORG_NAME|g" \
            "$file"
    fi
    echo "  ✓ $file"
done

# Step 2: Rename directories containing {{APP_NAME}}
echo ""
echo "[2/4] Renaming module directories..."
for dir in $(find . -maxdepth 1 -type d -name '*{{APP_NAME}}*' | sort); do
    newdir=$(echo "$dir" | sed "s/{{APP_NAME}}/$APP_NAME/g")
    mv "$dir" "$newdir"
    echo "  ✓ $dir -> $newdir"
done

# Also rename nested directories/files with {{APP_NAME}}
find . -depth -name '*{{APP_NAME}}*' ! -path './.git/*' | while read -r path; do
    newpath=$(echo "$path" | sed "s/{{APP_NAME}}/$APP_NAME/g")
    mv "$path" "$newpath"
    echo "  ✓ $path -> $newpath"
done

# Step 3: Create proper Java package directories and move source files
echo ""
echo "[3/4] Setting up Java package structure..."
for src_dir in $(find . -path '*/src/main/java' -type d ! -path './.git/*') \
               $(find . -path '*/src/test/java' -type d ! -path './.git/*'); do
    # If there are files directly with placeholder paths, move them
    placeholder_dir="$src_dir/{{BASE_PACKAGE_PATH}}"
    if [ -d "$placeholder_dir" ]; then
        target_dir="$src_dir/$BASE_PACKAGE_PATH"
        mkdir -p "$target_dir"
        # Move all contents
        if [ "$(ls -A "$placeholder_dir" 2>/dev/null)" ]; then
            cp -r "$placeholder_dir/"* "$target_dir/" 2>/dev/null || true
        fi
        # Remove placeholder directory tree
        rm -rf "$src_dir/{{BASE_PACKAGE_PATH}}"
        echo "  ✓ $target_dir"
    fi
    # Create the package directory if it doesn't exist
    mkdir -p "$src_dir/$BASE_PACKAGE_PATH"
done

# Step 4: Clean up
echo ""
echo "[4/4] Cleaning up..."
rm -f init-project.sh
echo "  ✓ Removed init-project.sh"

echo ""
echo "==========================================================="
echo " Done! Your project '$APP_NAME' is ready."
echo "==========================================================="
echo ""
echo "Next steps:"
echo "  1. Review the generated files"
echo "  2. Run: ./mvnw clean install"
echo "  3. Start coding in the domain module!"
echo ""
