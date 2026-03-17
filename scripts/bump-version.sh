#!/usr/bin/env bash
set -euo pipefail

# Bump version across all Snake Duel artifacts:
#   - manifest.json
#   - hecate-app-snake-dueld/src/hecate_app_snake_dueld.app.src
#   - hecate-app-snake-dueld/apps/run_snake_duel/src/run_snake_duel.app.src
#   - hecate-app-snake-dueld/apps/query_snake_duel/src/query_snake_duel.app.src
#   - hecate-app-snake-dueld/src/app_snake_duel.erl (manifest/0 version)
#   - hecate-app-snake-dueld/rebar.config (relx release)
#   - hecate-app-snake-duelw/package.json

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <new-version>"
    echo "Example: $0 0.4.0"
    exit 1
fi

NEW_VERSION="$1"

# Validate semver format
if ! [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be semver (X.Y.Z), got: $NEW_VERSION"
    exit 1
fi

echo "Bumping to version $NEW_VERSION"

# 1. manifest.json
MANIFEST="$REPO_ROOT/manifest.json"
sed -i "s/\"version\": \"[0-9]*\.[0-9]*\.[0-9]*\"/\"version\": \"$NEW_VERSION\"/" "$MANIFEST"
echo "  Updated $MANIFEST"

# 2. Root app.src
APP_SRC="$REPO_ROOT/hecate-app-snake-dueld/src/hecate_app_snake_dueld.app.src"
sed -i "s/{vsn, \"[0-9]*\.[0-9]*\.[0-9]*\"}/{vsn, \"$NEW_VERSION\"}/" "$APP_SRC"
echo "  Updated $APP_SRC"

# 3. Domain app.src files
for APP_SRC_FILE in \
    "$REPO_ROOT/hecate-app-snake-dueld/apps/run_snake_duel/src/run_snake_duel.app.src" \
    "$REPO_ROOT/hecate-app-snake-dueld/apps/query_snake_duel/src/query_snake_duel.app.src"; do
    sed -i "s/{vsn, \"[0-9]*\.[0-9]*\.[0-9]*\"}/{vsn, \"$NEW_VERSION\"}/" "$APP_SRC_FILE"
    echo "  Updated $APP_SRC_FILE"
done

# 4. app_snake_duel.erl — version => <<"X.Y.Z">> (only version, not min_sdk_version)
CALLBACK="$REPO_ROOT/hecate-app-snake-dueld/src/app_snake_duel.erl"
sed -i "s/^\( *version => <<\"\)[0-9]*\.[0-9]*\.[0-9]*/\1$NEW_VERSION/" "$CALLBACK"
echo "  Updated $CALLBACK"

# 5. rebar.config — {release, {hecate_app_snake_dueld, "X.Y.Z"}
REBAR_CONFIG="$REPO_ROOT/hecate-app-snake-dueld/rebar.config"
sed -i "s/{release, {hecate_app_snake_dueld, \"[0-9]*\.[0-9]*\.[0-9]*\"}/{release, {hecate_app_snake_dueld, \"$NEW_VERSION\"}/" "$REBAR_CONFIG"
echo "  Updated $REBAR_CONFIG"

# 6. package.json
PACKAGE_JSON="$REPO_ROOT/hecate-app-snake-duelw/package.json"
sed -i "s/\"version\": \"[0-9]*\.[0-9]*\.[0-9]*\"/\"version\": \"$NEW_VERSION\"/" "$PACKAGE_JSON"
echo "  Updated $PACKAGE_JSON"

echo ""
echo "Version bumped to $NEW_VERSION in all artifacts."
echo "Next steps:"
echo "  1. Update CHANGELOG.md"
echo "  2. git add -A && git commit -m 'chore: Release v$NEW_VERSION'"
echo "  3. git tag v$NEW_VERSION"
echo "  4. git push && git push --tags"
