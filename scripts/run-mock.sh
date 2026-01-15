#!/usr/bin/env bash
#
# Run the app with mock data providers in Chrome.
#
# Usage: ./scripts/run-mock.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

flutter run -t lib/main_mock.dart -d chrome
