# Use a specific, stable base image
FROM ubuntu:22.04

# Set environment variables for non-interactive apt operations
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and create user/group in a single RUN layer.
# Ensure all commands are correctly chained and handle potential prompts.
RUN apt-get update && \
    apt install --only-upgrade -y linux-libc-dev && \
    apt-get install -y iproute2 vim netcat-openbsd && \
    addgroup --gid 10008 choreo && \
    adduser --disabled-password --gecos "" --no-create-home --uid 10008 --ingroup choreo choreouser && \
    usermod -aG sudo choreouser && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a dedicated directory for the application
# This must be a separate instruction, not part of the RUN command.
WORKDIR /app

# Create dummy web content.
RUN echo "Terminal ativo via tmate..." > index.html

# Change ownership of the /app directory to the new user.
# Use the correct username: choreouser.
# This should be done *before* other files are copied if they need to be owned by this user.
RUN chown -R choreouser:choreo /app

# Expose the port that Render requires.
EXPOSE 8080

# Copy the startup script into the image.
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Switch to the non-root user for running the application.
USER choreouser

# Set the command to be executed when the container starts.
CMD ["/usr/local/bin/start.sh"]
