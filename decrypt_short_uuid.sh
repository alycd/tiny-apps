#!/bin/bash

decrypt() {
    local short="$1"
    # Minecraft's "short UUID" format: _ → /   and   - → +
    local fixed=$(echo "$short" | sed 's/_/\//g; s/-/+/g')

    # Add padding if needed (some implementations omit it)
    local padded=$(echo "$fixed" | sed 's/=$//')  # remove trailing = if present
    case $((${#padded} % 4)) in
        2) padded="${padded}==" ;;
        3) padded="${padded}="  ;;
    esac

    # Decode Base64 → raw bytes → hex → insert dashes in UUID positions
    echo "$padded" \
        | base64 --decode 2>/dev/null \
        | xxd -p -c 16 \
        | sed -E 's/^(.{8})(.{4})(.{4})(.{4})(.{12})$/\1-\2-\3-\4-\5/'
}

if [ $# -gt 0 ]; then
    for val in "$@"; do
        echo "Encrypted : $val"
        echo "Decrypted : $(decrypt "$val")"
        echo "--------------------------"
    done
else
    echo "Usage: $0 <short-uuid> [more...]"
    echo
    echo "Example:"
    echo "  $0 ZRsDmlhHRgO0x97fZAm7Cw"
    echo "  → 651b039a-5847-4603-b4c7-dedf6409bb0b"
fi