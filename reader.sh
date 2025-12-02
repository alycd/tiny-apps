#!/bin/bash

FIFO="/tmp/test.fifo"

# Ensure it exists
[ -p "$FIFO" ] || mkfifo "$FIFO"

echo "Reader waiting for messages... (CTRL+C to exit)"

# Read lines forever
while true; do
    if read line < "$FIFO"; then
        echo "Received: $line"
    fi
done
