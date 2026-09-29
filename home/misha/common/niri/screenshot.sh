#!/usr/bin/env bash
set -euo pipefail

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"

intel_icd=/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json

path="$(dms screenshot region --dir "$dir" --no-notify --json 2>/dev/null | jq -r '.path // empty')" || path=""
[[ -n "$path" && -f "$path" ]] || exit 0

action="$(timeout 90 notify-send \
  --app-name=Screenshot \
  --icon="$path" \
  --action=edit=Edit \
  --action=delete=Delete \
  --wait \
  "Screenshot captured" "$(basename "$path")")" || action=""

case "$action" in
  edit)
    VK_DRIVER_FILES="$intel_icd" VK_ICD_FILENAMES="$intel_icd" satty \
      --filename "$path" \
      --output-filename "$path" \
      --copy-command wl-copy \
      --actions-on-enter save-to-clipboard \
      --save-after-copy \
      --early-exit all \
      --no-window-decoration
    ;;
  delete)
    rm -f -- "$path"
    ;;
esac
