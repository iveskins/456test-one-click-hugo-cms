#!/bin/bash

# Define base directories
CONTENT_DIR="site/content"
LAYOUTS_DIR="site/layouts/section"
PARTIALS_DIR="site/layouts/partials"
NAV_FILE="site/layouts/partials/nav.html"
SHORTCODES_DIR="site/layouts/shortcodes"

# Step 1: Create directories and _index.md files in the content folder
echo "Creating directories and _index.md files in $CONTENT_DIR..."

declare -a SECTIONS=("bio" "projects" "performances" "upcoming-works" "blog" "teaching" "supporters" "history" "contact" "media")

for section in "${SECTIONS[@]}"; do
  mkdir -p "$CONTENT_DIR/$section"
  echo "Created directory: $CONTENT_DIR/$section"

  # Add an _index.md file in each directory with basic front matter
  if [[ ! -f "$CONTENT_DIR/$section/_index.md" ]]; then
    cat <<EOF > "$CONTENT_DIR/$section/_index.md"
---
title: "${section^}"
description: "Description for $section page"
---
EOF
    echo "Added _index.md to $CONTENT_DIR/$section"
  fi
done

# Step 2: Create layout files for each section in layouts/section if they don't already exist
echo "Creating layout files in $LAYOUTS_DIR..."

for section in "${SECTIONS[@]}"; do
  layout_file="$LAYOUTS_DIR/$section.html"
  if [[ ! -f "$layout_file" ]]; then
    cat <<EOF > "$layout_file"
{{ define "main" }}
    <h1>{{ .Title }}</h1>
    <p>{{ .Params.description }}</p>
    <!-- Custom layout for $section goes here -->
{{ end }}
EOF
    echo "Created layout file: $layout_file"
  fi
done

# Step 3: Create or update common partials in layouts/partials
echo "Creating or updating partials in $PARTIALS_DIR..."

# Define partials content
declare -A PARTIAL_CONTENTS

PARTIAL_CONTENTS["media.html"]='<div class="media-container">
    {{ if .Params.image }}
        <img src="{{ .Params.image }}" alt="{{ .Title }}">
    {{ end }}
    {{ if .Params.video }}
        <div class="video-container">
            <iframe src="{{ .Params.video }}" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
        </div>
    {{ end }}
</div>'

PARTIAL_CONTENTS["up-next-teaser.html"]='<div class="up-next-teaser">
    <h2>Up Next: {{ .Params.title }}</h2>
    <p>{{ .Params.description }}</p>
    <a href="/upcoming-works">Learn more</a>
</div>'

PARTIAL_CONTENTS["performance-list.html"]='<div class="performance-list">
    {{ range .Pages }}
        <article>
            <h2><a href="{{ .RelPermalink }}">{{ .Title }}</a></h2>
            {{ .Params.description }}
            {{ if .Params.image }}
                <img src="{{ .Params.image }}" alt="{{ .Title }}">
            {{ end }}
        </article>
    {{ end }}
</div>'

# Create each partial
for partial in "${!PARTIAL_CONTENTS[@]}"; do
  partial_file="$PARTIALS_DIR/$partial"
  echo "${PARTIAL_CONTENTS[$partial]}" > "$partial_file"
  echo "Created partial: $partial_file"
done

# Step 4: Update the navigation bar in nav.html
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

# Step 5: Create shortcodes for media embedding
echo "Creating shortcodes for media in $SHORTCODES_DIR..."

mkdir -p "$SHORTCODES_DIR"
echo '<div class="video-container">
    <iframe width="560" height="315" src="{{ .Get "src" }}" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
</div>' > "$SHORTCODES_DIR/video.html"

echo "Shortcodes created successfully in $SHORTCODES_DIR"

# Final message
echo "All updates completed successfully!"

