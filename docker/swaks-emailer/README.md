# SWAKS Email Sender Docker Image

Docker image for running email tests using `swaks` (Swiss Army Knife for SMTP).

## 📋 Overview

This Docker image packages:
- `swaks` - SMTP testing tool
- `send-email.sh` - Generic SMTP delivery test script
- `send-blue-modo-test-emails.sh` - Blue Modo specific test emails

## 🚀 Quick Start

### 1. Build the image
```bash
./build.sh
```

Or manually:
```bash
docker build -t swaks-emailer -f Dockerfile ../../
```

### 2. Run the container
```bash
export SMTP_PASSWORD="your-password-here"
./run.sh
```

Or manually:
```bash
docker run --rm \
    -e SMTP_PASSWORD="your-password" \
    swaks-emailer
```

## 🔑 Environment Variables

### Required
- `SMTP_PASSWORD` - Your SMTP password

### Optional (with defaults)
- `SMTP_SERVER` - Default: `smtp.ongage.tiny-email.com`
- `SMTP_PORT` - Default: `2525`
- `AUTH_METHOD` - Default: `LOGIN`

## 📝 Examples

### Basic usage (runs send-blue-modo-test-emails.sh)
```bash
export SMTP_PASSWORD="my-secret-password"
./run.sh
```

### Run send-email.sh directly with custom parameters
```bash
# Using the helper script
export SMTP_USER="user@example.com"
export SMTP_PASSWORD="my-password"
export FROM_EMAIL="user@example.com"
export TO_EMAILS="recipient@example.com"
./run-send-email.sh
```

### Run send-email.sh manually (override CMD)
```bash
docker run --rm \
    -e SMTP_USER="user@example.com" \
    -e SMTP_PASSWORD="my-password" \
    -e FROM_EMAIL="user@example.com" \
    -e TO_EMAILS="recipient1@example.com,recipient2@example.com" \
    swaks-emailer \
    /app/send-email.sh
```

### Custom SMTP server
```bash
docker run --rm \
    -e SMTP_PASSWORD="my-password" \
    -e SMTP_SERVER="smtp.example.com" \
    -e SMTP_PORT="587" \
    swaks-emailer
```

### Run with all environment variables
```bash
docker run --rm \
    -e SMTP_PASSWORD="my-password" \
    -e SMTP_SERVER="smtp.ongage.tiny-email.com" \
    -e SMTP_PORT="2525" \
    -e AUTH_METHOD="PLAIN" \
    swaks-emailer
```

## 🏗️ Build Context

The Dockerfile builds from the repository root (`../../`) to access:
- `send-email.sh`
- `send-blue-modo-test-emails.sh`

## 📦 Image Details

- **Base Image**: Alpine Linux (lightweight)
- **Size**: ~50MB
- **Tools**: bash, perl, swaks, SSL libraries
