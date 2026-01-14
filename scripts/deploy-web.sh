#!/usr/bin/env bash
#
# Build and deploy web release to squishygoose directory.
#
# Expected directory structure:
#   parent/
#     timeshare/      <- this repo
#     squishygoose/   <- deployment target
#
# Usage: ./scripts/deploy-web.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SQUISHYGOOSE_DIR="$PROJECT_DIR/../squishygoose"
TARGET_DIR="$SQUISHYGOOSE_DIR/timeshare-web"

cd "$PROJECT_DIR"

echo "Building web release..."
flutter build web --release --dart-define=ENV=prod

if [ ! -d "$SQUISHYGOOSE_DIR" ]; then
    echo ""
    echo "ERROR: squishygoose directory not found: $SQUISHYGOOSE_DIR"
    echo ""
    echo "Expected directory structure:"
    echo "  parent/"
    echo "    timeshare/      <- this repo ($(basename "$PROJECT_DIR"))"
    echo "    squishygoose/   <- must exist as sibling directory"
    echo ""
    echo "Please ensure squishygoose is a sibling directory of timeshare."
    exit 1
fi

echo "Deploying to $TARGET_DIR..."
rm -rf "$TARGET_DIR"
cp -r build/web "$TARGET_DIR"

echo "Done! Web app deployed to $TARGET_DIR"
