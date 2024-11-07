#!/bin/bash

# Define base directories
CONTENT_DIR="site/content"
LAYOUTS_DIR="site/layouts/section"
PARTIALS_DIR="site/layouts/partials"
NAV_FILE="site/layouts/partials/nav.html"

# Step 1: Create new directories in the content folder
echo "Creating directories in $CONTENT_DIR..."

declare -a DIRECTORIES=("bio" "projects" "performances" "upcoming-works" "blog" "teaching" "supporters" "history" "contact" "media")

for dir in "${DIRECTORIES[@]}"; do
  mkdir -p "$CONTENT_DIR/$dir"
  echo "Created directory: $CONTENT_DIR/$dir"

  # Add an _index.md file in each directory with basic front matter
  if [[ ! -f "$CONTENT_DIR/$dir/_index.md" ]]; then
    cat <<EOF > "$CONTENT_DIR/$dir/_index.md"
---
title: "${dir^}"
description: "Description for $dir page"
---
EOF
    echo "Added _index.md to $CONTENT_DIR/$dir"
  fi
done

# Step 2: Create layout files for each section in layouts/section if they don't already exist
echo "Creating layout files in $LAYOUTS_DIR..."

for dir in "${DIRECTORIES[@]}"; do
  layout_file="$LAYOUTS_DIR/$dir.html"
  if [[ ! -f "$layout_file" ]]; then
    cat <<EOF > "$layout_file"
{{ define "main" }}
    <h1>{{ .Title }}</h1>
    <p>{{ .Params.description }}</p>
    <!-- Custom layout for $dir goes here -->
{{ end }}
EOF
    echo "Created layout file: $layout_file"
  fi
done

# Step 3: Update the navigation bar in nav.html
echo "Updating navigation bar in $NAV_FILE..."

# Check if nav.html exists
if [[ ! -f $NAV_FILE ]]; then
  echo "Error: $NAV_FILE not found!"
  exit 1
fi

# Define new navigation content
NEW_NAV_CONTENT=$(cat <<'EOF'
<nav data-nav class="flex justify-between items-center center bg-white divider-grey relative">

    <!-- Logo -->
    <a href="/" class="pa3 db mr4 h-100 w3 flex-none">
        <img src="/img/logo.svg" alt="Choreographer logo" class="br0 db mb0 w-100"/>
    </a>

    <!-- Mobile Menu Toggle -->
    <div data-mobile-menu class="mobile-menu-container">
        <svg viewBox="0 0 100 80" width="40" height="25" class="mobile-menu-icon">
            <rect class="menu-icon-top mobile-menu-inner" width="100" height="8"></rect>
            <rect class="menu-icon-middle mobile-menu-inner" y="30" width="100" height="8"></rect>
            <rect class="menu-icon-bottom mobile-menu-inner" y="60" width="100" height="8"></rect>
        </svg>
    </div>

    <!-- Primary Nav -->
    <ul class="flex b grey-3 nav-menu">
        <li><a href="/bio" class="pa3 no-underline db">Bio</a></li>
        <li><a href="/projects" class="pa3 no-underline db">Projects</a></li>
        <li><a href="/performances" class="pa3 no-underline db">Performances</a></li>
        <li><a href="/upcoming-works" class="pa3 no-underline db">Upcoming</a></li>
        <li><a href="/media" class="pa3 no-underline db">Media</a></li>
        <li><a href="/teaching" class="pa3 no-underline db">Teaching</a></li>
        <li><a href="/supporters" class="pa3 no-underline db">Supporters</a></li>
        <li><a href="/blog" class="pa3 no-underline db">Blog</a></li>
        <li><a href="/contact" class="pa3 no-underline db">Contact</a></li>
    </ul>

</nav>
EOF
)

# Replace the content in nav.html with the new navigation structure
echo "$NEW_NAV_CONTENT" > "$NAV_FILE"

echo "Navigation updated successfully in $NAV_FILE"

# Final message
echo "All updates completed successfully!"

