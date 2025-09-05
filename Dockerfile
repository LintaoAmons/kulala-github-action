FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    jq \
    nodejs \
    npm \
    python3 \
    python3-pip \
    gcc \
    g++ \
    make \
    ripgrep \
    fd-find \
    && rm -rf /var/lib/apt/lists/*

# Install grpcurl (using go install method)
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then GRPC_ARCH="x86_64"; elif [ "$ARCH" = "arm64" ]; then GRPC_ARCH="arm64"; fi && \
    wget -q https://github.com/fullstorydev/grpcurl/releases/download/v1.9.1/grpcurl_1.9.1_linux_${GRPC_ARCH}.tar.gz -O /tmp/grpcurl.tar.gz && \
    tar -xzf /tmp/grpcurl.tar.gz -C /usr/local/bin grpcurl && \
    rm /tmp/grpcurl.tar.gz && \
    chmod +x /usr/local/bin/grpcurl

# Install websocat for WebSocket support
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        wget -q https://github.com/vi/websocat/releases/latest/download/websocat.x86_64-unknown-linux-musl -O /usr/local/bin/websocat; \
    elif [ "$ARCH" = "arm64" ]; then \
        wget -q https://github.com/vi/websocat/releases/latest/download/websocat.aarch64-unknown-linux-musl -O /usr/local/bin/websocat; \
    fi && \
    chmod +x /usr/local/bin/websocat

# Install Neovim (use specific version for stability)
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        curl -LO https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz && \
        tar xzf nvim-linux64.tar.gz && \
        mv nvim-linux64/bin/nvim /usr/local/bin/ && \
        mv nvim-linux64/lib /usr/local/ && \
        mv nvim-linux64/share /usr/local/ && \
        rm -rf nvim-linux64*; \
    else \
        apt-get update && apt-get install -y neovim && rm -rf /var/lib/apt/lists/*; \
    fi

# Set up Neovim config directory
ENV XDG_CONFIG_HOME=/root/.config
ENV XDG_DATA_HOME=/root/.local/share

# Install nvim-treesitter and parsers
RUN mkdir -p ${XDG_DATA_HOME}/nvim/site/pack/treesitter/start && \
    git clone --depth 1 https://github.com/nvim-treesitter/nvim-treesitter.git \
    ${XDG_DATA_HOME}/nvim/site/pack/treesitter/start/nvim-treesitter

# Create minimal init.lua for treesitter
RUN mkdir -p ${XDG_CONFIG_HOME}/nvim && \
    echo 'require("nvim-treesitter.configs").setup({ \
    ensure_installed = { "http", "json", "xml", "html", "javascript", "graphql" }, \
    sync_install = true, \
    auto_install = false, \
    highlight = { enable = true } \
    })' > ${XDG_CONFIG_HOME}/nvim/init.lua

# Install tree-sitter parsers
RUN nvim --headless -c "TSInstallSync http json xml html javascript graphql" -c "qa" 2>/dev/null || true

# Clone kulala.nvim
RUN git clone --depth 1 https://github.com/mistweaverco/kulala.nvim.git /opt/kulala.nvim

# Make CLI scripts executable
RUN chmod +x /opt/kulala.nvim/lua/cli/kulala_cli.lua && \
    chmod +x /opt/kulala.nvim/lua/cli/kulala_ci.sh

# Add kulala CLI to PATH
ENV PATH="/opt/kulala.nvim/lua/cli:${PATH}"

# Create working directory
WORKDIR /workspace

# Create entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]