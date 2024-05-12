# Stage 1: Build Stage
FROM ubuntu AS build-stage

# Install required packages and clean up
RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    git \
    nodejs \
    npm && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up Node.js repository key
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

# Set up Node.js repository
ENV NODE_MAJOR=20
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# Update package lists from newly added repos
RUN apt-get update

# Install Node.js and Git
RUN apt-get install -y nodejs git

# Clone the repository into a temporary directory
RUN git clone https://github.com/summu97/react.js.git /tmp/react_repo

# Set working directory to the cloned repository
WORKDIR /tmp/react_repo

# Install dependencies and build
RUN npm install && \
    npm run build

# Stage 2: Running Stage with Apache
FROM httpd:latest AS running-stage

# Remove the default Apache index file
RUN rm /usr/local/apache2/htdocs/index.html

# Copy static files from build stage to Apache's HTML directory
COPY --from=build-stage /tmp/react_repo/build /usr/local/apache2/htdocs
