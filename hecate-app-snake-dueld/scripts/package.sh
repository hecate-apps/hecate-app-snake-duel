#!/usr/bin/env bash
set -euo pipefail

## Package the snake-duel plugin as a .tar.gz for in-VM loading.
##
## Output: _build/plugin/hecate-app-snake-duel.tar.gz
## Contents:
##   ebin/           - All compiled .beam files (consolidated from all apps)
##   priv/static/    - Frontend assets (if built)
##   manifest.json   - Plugin metadata

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="$ROOT_DIR/_build/plugin"
STAGING_DIR="$BUILD_DIR/staging"

echo "==> Compiling..."
cd "$ROOT_DIR"
rebar3 compile

echo "==> Preparing package..."
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR/ebin"

## Consolidate all .beam and .app files from root app + domain apps
DOMAIN_APPS=(
    hecate_app_snake_dueld
    run_snake_duel
    query_snake_duel
)

BEAM_COUNT=0
APP_COUNT=0
for app in "${DOMAIN_APPS[@]}"; do
    ebin_dir="$ROOT_DIR/_build/default/lib/$app/ebin"
    if [ -d "$ebin_dir" ]; then
        for f in "$ebin_dir"/*.beam; do
            [ -f "$f" ] && cp "$f" "$STAGING_DIR/ebin/" && BEAM_COUNT=$((BEAM_COUNT + 1))
        done
        for f in "$ebin_dir"/*.app; do
            [ -f "$f" ] && cp "$f" "$STAGING_DIR/ebin/" && APP_COUNT=$((APP_COUNT + 1))
        done
    fi
done

echo "  $BEAM_COUNT .beam files, $APP_COUNT .app files"

## Copy static assets if they exist
STATIC_DIR="$ROOT_DIR/priv/static"
if [ -d "$STATIC_DIR" ]; then
    mkdir -p "$STAGING_DIR/priv"
    cp -r "$STATIC_DIR" "$STAGING_DIR/priv/static"
    echo "  Static assets included"
else
    echo "  No static assets (run frontend build first)"
fi

## Copy manifest.json from repo root (single source of truth)
MANIFEST_SRC="$ROOT_DIR/../manifest.json"
if [ ! -f "$MANIFEST_SRC" ]; then
    echo "ERROR: manifest.json not found at $MANIFEST_SRC"
    exit 1
fi
cp "$MANIFEST_SRC" "$STAGING_DIR/manifest.json"

## Create the tarball (flat structure — ebin/ at tar root)
cd "$STAGING_DIR"
tar czf "$BUILD_DIR/hecate-app-snake-duel.tar.gz" .

echo "==> Package created: $BUILD_DIR/hecate-app-snake-duel.tar.gz"
