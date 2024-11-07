#!/bin/bash

# Define the shortcodes directory path
SHORTCODES_DIR="site/layouts/shortcodes"

# Create the shortcodes directory if it doesn't exist
mkdir -p "$SHORTCODES_DIR"

# Create YouTube Playlist shortcode
echo "Creating YouTube Playlist shortcode..."
cat << 'EOF' > "$SHORTCODES_DIR/youtubepl.html"
{{- $pc := .Page.Site.Config.Privacy.YouTube -}}
{{- if not $pc.Disable -}}
    {{- $ytHost := cond $pc.PrivacyEnhanced "www.youtube-nocookie.com" "www.youtube.com" -}}
    {{- $id := .Get "id" | default (.Get 0) -}}
    {{- $class := .Get "class" | default (.Get 1) -}}
    {{- $title := .Get "title" | default "YouTube Playlist" }}
    <div {{ with $class }}class="{{ . }}"{{ else }}style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden;"{{ end }}>
        <iframe src="https://{{ $ytHost }}/embed/videoseries?list={{ $id }}{{ with .Get "autoplay" }}{{ if eq . "true" }}&autoplay=1{{ end }}{{ end }}" {{ if not $class }}style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border:0;" {{ end }} allowfullscreen title="{{ $title }}"></iframe>
    </div>
{{ end -}}
EOF

echo "YouTube Playlist shortcode created at $SHORTCODES_DIR/youtubepl.html"

