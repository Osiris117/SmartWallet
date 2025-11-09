#!/bin/sh
# Helper: create a symlink named 'tools/flutter' pointing to an existing Flutter SDK.
# Usage: ./setup_flutter_symlink.sh /path/to/flutter

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 /absolute/path/to/flutter"
  exit 1
fi

TARGET="$1"
DEST_DIR="$(pwd)/frontend/tools"

if [ ! -d "$TARGET" ]; then
  echo "Target does not exist: $TARGET"
  exit 2
fi

mkdir -p "$DEST_DIR"
ln -sfn "$TARGET" "$DEST_DIR/flutter"
echo "Created symlink: $DEST_DIR/flutter -> $TARGET"
