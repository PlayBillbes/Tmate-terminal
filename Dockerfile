# Use a specific, stable base image
FROM ubuntu:22.04

# Set environment variables for non-interactive apt operations
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies in a single RUN layer to optimize image size
# and use --no-install-recommends to avoid installing unnecessary packages.
# apt-get clean and rm -rf /var/lib/apt/lists/* are crucial for minimizing image size.
RUN apt update && \
    apt install -y --no-install-recommends \
    curl \
    wget \
    gnupg2 \
    ca-certificates \
    software-properties-common \
    python3 \
    tmate \
    sudo && \
    rm -rf /var/lib/apt/lists/*

# Create a dedicated directory for the application
WORKDIR /app

# Create dummy web content. This line is fine as is, but consider if it's truly needed
# if your start.sh script will be generating/serving content.
RUN echo "Terminal ativo via tmate..." > index.html

# Best practice: Create user and group *before* changing ownership.
# Avoid hardcoding UIDs if possible, let Docker manage it, or define them
# in a build argument if they need to be specific for an external system.
# Adding a user to sudoers with NOPASSWD is generally discouraged in production
# unless absolutely necessary and with a strong understanding of the security implications.
# For a tmate setup, it might be acceptable for debugging/development.
RUN groupadd --system myuser && useradd --system --uid 100011 -g myuser myuser

# Change ownership of the /app directory to the new user.
# This should be done *before* other files are copied if they need to be owned by this user.
RUN chown -R myuser:myuser /app

# Expose the port that Render requires. This is a directive, not an active command.
EXPOSE 8080

# Copy the startup script into the image.
# It's better to copy it into a location accessible by the user, e.g., /usr/local/bin or /app.
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Switch to the non-root user for running the application.
# This is a critical security best practice.
USER myuser

# Set the command to be executed when the container starts.
# Use the exec form for CMD to ensure signals are properly handled.
CMD ["/usr/local/bin/start.sh"]
