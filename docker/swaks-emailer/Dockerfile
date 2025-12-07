# Use Alpine Linux for a smaller image
FROM alpine:latest

# Install swaks and its dependencies
RUN apk add --no-cache \
    bash \
    perl \
    perl-net-ssleay \
    perl-io-socket-ssl \
    ca-certificates \
    wget

# Install swaks
RUN wget -O /usr/local/bin/swaks https://jetmore.org/john/code/swaks/files/swaks-20201014.0/swaks && \
    chmod +x /usr/local/bin/swaks

# Create a working directory
WORKDIR /app

# Copy the scripts from the root of the repository
# Build context is set to ../../ so paths are relative to repo root
COPY send-email.sh /app/send-email.sh
COPY send-blue-modo-test-emails.sh /app/send-blue-modo-test-emails.sh

# Make scripts executable
RUN chmod +x /app/send-email.sh /app/send-blue-modo-test-emails.sh

# Add /app to PATH so send-email.sh can be found
ENV PATH="/app:${PATH}"

# Set default environment variables (these should be overridden at runtime)
ENV SMTP_SERVER="smtp.ongage.tiny-email.com"
ENV SMTP_PORT="2525"
ENV AUTH_METHOD="LOGIN"
ENV SMTP_PASSWORD=""

# Default command
CMD ["/app/send-blue-modo-test-emails.sh"]
