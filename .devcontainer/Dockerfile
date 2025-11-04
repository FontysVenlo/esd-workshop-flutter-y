# Use Ubuntu as base image
FROM ubuntu:24.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Create a non-root user
RUN useradd --create-home --shell /bin/bash vscode

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    wget \
    file \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Give vscode user sudo privileges
RUN echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Chrome (needed for Flutter web testing)
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Set Flutter version
ENV FLUTTER_VERSION=3.24.3
ENV FLUTTER_HOME=/home/vscode/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

# Download and install Flutter as vscode user
USER vscode
RUN git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME

# Set working directory
WORKDIR /workspace

# Pre-download Flutter dependencies and enable web
RUN flutter doctor \
    && flutter config --enable-web \
    && flutter precache --web

# Verify installation
RUN flutter doctor -v

# Set the default command
CMD ["/bin/bash"]