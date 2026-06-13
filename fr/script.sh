#!/usr/bin/env bash
set -euo pipefail

URL="https://vpsmakersecurity.jishnudiscord7.workers.dev"
HOST="vpsmakersecurity.jishnudiscord7.workers.dev"
NETRC="${HOME}/.netrc"

# Base64 decode helper
b64d() { printf '%s' "$1" | base64 -d; }

# Credentials (same as your script)
USER_B64="amlzaG51"
PASS_B64="amlzaG51aEBja2VyMTIz"

USER_RAW="$(b64d "$USER_B64")"
PASS_RAW="$(b64d "$PASS_B64")"

if [[ -z "$USER_RAW" || -z "$PASS_RAW" ]]; then
  echo "Credential decode failed." >&2
  exit 1
fi

# Ensure curl exists
command -v curl >/dev/null 2>&1 || {
  echo "curl is required but not installed." >&2
  exit 1
}

# Secure .netrc setup
touch "$NETRC"
chmod 600 "$NETRC"

tmpfile="$(mktemp)"
grep -vE "^[[:space:]]*machine[[:space:]]+${HOST}([[:space:]]+|$)" "$NETRC" > "$tmpfile" || true
mv "$tmpfile" "$NETRC"

{
  printf 'machine %s login %s password %s\n' "$HOST" "$USER_RAW" "$PASS_RAW"
} >> "$NETRC"

# Download content safely (DO NOT execute it)
output_file="downloaded_content.sh"

if curl -fsS --netrc -o "$output_file" "$URL"; then
  echo "Download successful: $output_file"
  echo "---- file contents ----"
  cat "$output_file"
else
  echo "Authentication or download failed." >&2
  exit 1
fi