#!/bin/bash

# Usage: ./compare.sh /path/to/source /path/to/target

SOURCE="$1"
TARGET="$2"

if [ -z "$SOURCE" ] || [ -z "$TARGET" ]; then
  echo "Usage: $0 /path/to/source /path/to/target"
  exit 1
fi

# Loop through all files in the source directory
find "$SOURCE" -type f | while read -r file; do
  # Determine the relative path from the source root
  rel_path="${file#$SOURCE/}"
  
  # Determine the corresponding target file
  target_file="$TARGET/$rel_path"
  
  if [ -f "$target_file" ]; then
    if diff -u "$file" "$target_file" > /dev/null; then
      echo "No diff: $rel_path"
    else
      echo "Differs: $rel_path"
      echo "--------------------"
      diff -u "$file" "$target_file"
      echo "--------------------"
    fi
  else
    echo "Missing on target: $rel_path"
  fi
done
