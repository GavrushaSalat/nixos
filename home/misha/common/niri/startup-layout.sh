#!/usr/bin/env bash
set -uo pipefail

read_app_ids() {
  IFS='|' read -r firefox ghostty obsidian telegram happ < <(
    jq -r '
      def first_id(re):
        [.[] | select((.app_id // "") | test(re; "i"))][0].id // "";
      [
        first_id("^firefox-nightly$"),
        first_id("^com\\.mitchellh\\.ghostty$"),
        first_id("^md\\.Obsidian$"),
        first_id("^org\\.telegram\\.desktop$"),
        first_id("happ")
      ] | join("|")
    ' <<<"$windows"
  )
}

# Wait until the startup windows have either all appeared or the set of
# available windows has remained unchanged for five seconds.
last_signature=""
stable_polls=0
for ((attempt = 0; attempt < 30; attempt++)); do
  windows="$(niri msg --json windows 2>/dev/null || true)"
  if [[ -z "$windows" ]]; then
    sleep 0.5
    continue
  fi

  read_app_ids
  signature="$firefox|$ghostty|$obsidian|$telegram|$happ"

  if [[ -n "$firefox" && -n "$ghostty" && -n "$obsidian" && -n "$telegram" && -n "$happ" ]]; then
    break
  elif [[ "$signature" == "$last_signature" && "$signature" != "||||" ]]; then
    stable_polls=$((stable_polls + 1))
    [[ $stable_polls -ge 10 ]] && break
  else
    last_signature="$signature"
    stable_polls=0
  fi

  sleep 0.5
done

windows="$(niri msg --json windows 2>/dev/null || true)"
[[ -n "$windows" ]] || exit 0
read_app_ids

previous_window="$(jq -r '[.[] | select(.is_focused)][0].id // ""' <<<"$windows")"
previous_workspace="$(niri msg --json workspaces 2>/dev/null | jq -r '[.[] | select(.is_focused)][0].name // ""')"

arrange_columns() {
  local index=1 id
  for id in "$@"; do
    [[ -n "$id" ]] || continue
    niri msg action focus-window --id "$id" >/dev/null 2>&1 || continue
    niri msg action move-column-to-index "$index" >/dev/null 2>&1 || true
    index=$((index + 1))
  done
}

# Workspace 2: browser, terminal. Workspace 3: notes, chat, VPN.
arrange_columns "$firefox" "$ghostty"
arrange_columns "$obsidian" "$telegram" "$happ"

if [[ -n "$previous_window" ]]; then
  niri msg action focus-window --id "$previous_window" >/dev/null 2>&1 || true
elif [[ -n "$previous_workspace" ]]; then
  niri msg action focus-workspace "$previous_workspace" >/dev/null 2>&1 || true
fi
