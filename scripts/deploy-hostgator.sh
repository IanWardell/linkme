#!/usr/bin/env bash
set -Eeuo pipefail

# HostGator cron deployment for ianwardell.com.
# Confirm WEB_ROOT matches the domain's document root in cPanel before running.
REPO_URL="${REPO_URL:-https://github.com/IanWardell/linkme.git}"
BRANCH="${BRANCH:-release}"
CHECKOUT_DIR="${CHECKOUT_DIR:-$HOME/repositories/linkme}"
WEB_ROOT="${WEB_ROOT:-$HOME/public_html}"
LOCK_DIR="${LOCK_DIR:-$HOME/.ianwardell-deploy.lock}"

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

cleanup() {
  rmdir "$LOCK_DIR" 2>/dev/null || true
}

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  log "Another deployment is already running; exiting."
  exit 0
fi
trap cleanup EXIT

command -v git >/dev/null 2>&1 || { log "git is not available."; exit 1; }

case "$WEB_ROOT" in
  ""|"/"|"$HOME")
    log "Refusing unsafe WEB_ROOT: ${WEB_ROOT:-<empty>}"
    exit 1
    ;;
esac

mkdir -p "$(dirname "$CHECKOUT_DIR")" "$WEB_ROOT"

if [[ ! -d "$CHECKOUT_DIR/.git" ]]; then
  log "Cloning $REPO_URL"
  git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$CHECKOUT_DIR"
else
  log "Fetching origin/$BRANCH"
  git -C "$CHECKOUT_DIR" fetch --depth 1 origin "$BRANCH"
  git -C "$CHECKOUT_DIR" checkout -B "$BRANCH" FETCH_HEAD
  git -C "$CHECKOUT_DIR" clean -fdx
fi

[[ -f "$CHECKOUT_DIR/site/index.html" ]] || {
  log "Expected site/index.html was not found."
  exit 1
}

# Preserve cPanel/AutoSSL's .well-known directory while replacing the site.
find "$WEB_ROOT" -mindepth 1 -maxdepth 1 ! -name '.well-known' -exec rm -rf -- {} +
cp -a "$CHECKOUT_DIR/site/." "$WEB_ROOT/"

log "Deployment complete: $WEB_ROOT"
