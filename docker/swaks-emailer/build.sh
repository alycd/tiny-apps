#!/bin/bash
# Build the swaks-emailer Docker image

cd "$(dirname "$0")"

echo "Building swaks-emailer Docker image..."
docker build -t swaks-emailer -f Dockerfile ../../

echo ""
echo "✅ Build complete! Image: swaks-emailer"
echo ""
echo "To run the container:"
echo "  docker run --rm -e SMTP_PASSWORD=\"your-password\" swaks-emailer"
echo ""
echo "Or use the run.sh script:"
echo "  ./run.sh"
