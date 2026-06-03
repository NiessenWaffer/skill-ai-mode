#!/usr/bin/env bash
set -euo pipefail

# Cross-platform installer (macOS/Linux)
# Copies gemini.md, Planning mode/, Developer mode/, and Debugging mode/ into ~/.agents/skills (or a custom destination)
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/NiessenWaffer/skill-ai-mode/main/install.sh | bash -s -- -y
#   curl -fsSL https://raw.githubusercontent.com/NiessenWaffer/skill-ai-mode/main/install.sh | bash -s -- -y -d "$HOME/.agents/skills"

DESTINATION="${DESTINATION:-}"
AUTO_YES=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--destination)
      DESTINATION="$2"; shift 2 ;;
    -y|--yes)
      AUTO_YES=1; shift ;;
    *)
      echo "Unknown argument: $1" >&2
      echo "Usage: install.sh [-y|--yes] [-d|--destination <path>]" >&2
      exit 1 ;;
  esac
done

if [[ -z "${DESTINATION}" ]]; then
  DESTINATION="$HOME/.agents/skills"
fi

ARCHIVE_URL="https://github.com/NiessenWaffer/skill-ai-mode/archive/refs/heads/main.tar.gz"
TMP_ROOT="$(mktemp -d 2>/dev/null || mktemp -d -t skill-ai-mode)"
TAR_PATH="$TMP_ROOT/repo.tar.gz"
EXTRACT_PATH="$TMP_ROOT/extract"
mkdir -p "$EXTRACT_PATH"

if [[ $AUTO_YES -eq 0 ]]; then
  echo "This will install skill-ai-mode into your global AI skills folder: $DESTINATION"
  echo "It downloads the GitHub repo archive, then copies gemini.md plus the full Planning, Developer, and Debugging mode folders recursively."
  read -r -p "Do you want to install? (y/n) " CONFIRM
  case "$CONFIRM" in
    y|Y|yes|YES) ;; 
    *) echo "Install cancelled."; exit 0 ;;
  esac
fi

# Download
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$ARCHIVE_URL" -o "$TAR_PATH"
elif command -v wget >/dev/null 2>&1; then
  wget -q "$ARCHIVE_URL" -O "$TAR_PATH"
else
  echo "Neither curl nor wget is available. Please install one of them." >&2
  exit 1
fi

# Extract
 tar -xzf "$TAR_PATH" -C "$EXTRACT_PATH"
 
# Locate root of extracted repo (first directory inside)
ROOT_DIR="$(find "$EXTRACT_PATH" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
if [[ -z "$ROOT_DIR" ]]; then
  echo "Unable to locate extracted repository contents." >&2
  exit 1
fi

mkdir -p "$DESTINATION"

# Copy files (quotes handle spaces in folder names)
cp -R "$ROOT_DIR/gemini.md" "$DESTINATION/"
cp -R "$ROOT_DIR/Planning mode" "$DESTINATION/"
cp -R "$ROOT_DIR/Developer mode" "$DESTINATION/"
cp -R "$ROOT_DIR/Debugging mode" "$DESTINATION/"
cp -R "$ROOT_DIR/SKILLS_VERSION" "$DESTINATION/" 2>/dev/null || true

echo "Installed skill-ai-mode to $DESTINATION"
if [[ -f "$DESTINATION/SKILLS_VERSION" ]]; then
  ver=$(tr -d '\r' < "$DESTINATION/SKILLS_VERSION" | tr -d '\n')
  echo "Skills version: $ver"
fi
printf "Configure your AI editor/CLI to read %s\n" "$DESTINATION"

# Cleanup
rm -rf "$TMP_ROOT"
