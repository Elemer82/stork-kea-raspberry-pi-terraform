# Use a base image compatible with ARM
FROM debian:bullseye-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV STORK_VERSION=1.12.0

# Install required dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    lsb-release \
    build-essential \
    git \
    cmake \
    pkg-config \
    libboost-all-dev \
    liblog4cplus-dev \
    libpq-dev \
    postgresql-client \
    libssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone the Stork repo and checkout the desired version
RUN git clone https://github.com/isc-projects/stork.git /stork && \
    cd /stork && \
    git checkout v${STORK_VERSION}

# Build Stork
WORKDIR /stork
RUN mkdir build && cd build && cmake .. && make -j$(nproc)

# Expose required ports
EXPOSE 8080 5678

# Run the server (adjust for agent if needed)
CMD ["/stork/build/src/stork-server"]
# Run the agent (uncomment if needed)
# CMD ["/stork/build/src/stork-agent"]