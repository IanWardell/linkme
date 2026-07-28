#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INDEX_FILE="$ROOT_DIR/site/index.html"

test -f "$INDEX_FILE"
test -f "$ROOT_DIR/site/assets/css/styles.css"
test -f "$ROOT_DIR/site/assets/images/ian-wardell-headshot.jpg"

grep -Fq 'https://www.linkedin.com/in/ian-wardell/' "$INDEX_FILE"
grep -Fq 'https://www.research.ianwardell.com/' "$INDEX_FILE"
grep -Fq 'https://www.git.ianwardell.com/' "$INDEX_FILE"
grep -Fq 'https://www.resume.ianwardell.com/' "$INDEX_FILE"

printf 'Static site validation passed.\n'
