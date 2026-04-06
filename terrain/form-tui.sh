#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="$HOME/roulotte/terrain/forms"
mkdir -p "$OUT_DIR"
FILE="$OUT_DIR/form_$(date +%Y%m%d_%H%M%S).json"

read -rp "Nom du bénévole: " name
read -rp "Site: " site
read -rp "Observations: " obs

cat > "$FILE" <<EOF
{
  "timestamp": "$(date --iso-8601=seconds)",
  "volunteer": "$name",
  "site": "$site",
  "observations": "$obs"
}
EOF

echo "Form saved to $FILE"
