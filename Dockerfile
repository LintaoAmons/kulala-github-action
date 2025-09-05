FROM chn2guevara/nvim:stable

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /root/.config/nvim \
    && mkdir -p /root/.local/share/nvim/site/pack/kulala/start

# Clone Kulala plugin
RUN git clone https://github.com/mistweaverco/kulala.nvim.git \
    /root/.local/share/nvim/site/pack/kulala/start/kulala.nvim

# Clone nvim-treesitter plugin
RUN git clone https://github.com/nvim-treesitter/nvim-treesitter.git \
    /root/.local/share/nvim/site/pack/kulala/start/nvim-treesitter

# Create minimal init.lua for Kulala
RUN echo 'vim.g.mapleader = " "\n\
vim.g.maplocalleader = " "\n\
\n\
-- Setup nvim-treesitter\n\
require("nvim-treesitter.configs").setup({\n\
  ensure_installed = { "http", "json", "xml", "html", "graphql" },\n\
  sync_install = true,\n\
  auto_install = false,\n\
  highlight = {\n\
    enable = true,\n\
  },\n\
})\n\
\n\
-- Setup Kulala\n\
require("kulala").setup({\n\
  default_view = "headers_body",\n\
  debug = false,\n\
})\n\
\n\
-- Key mappings for Kulala\n\
vim.keymap.set("n", "<leader>r", require("kulala").run)\n\
vim.keymap.set("n", "<leader>ra", require("kulala").run_all)\n\
vim.keymap.set("n", "<leader>t", require("kulala").toggle_view)\n\
vim.keymap.set("n", "<leader>e", require("kulala").set_selected_env)\n\
' > /root/.config/nvim/init.lua

# Install treesitter parsers
RUN nvim --headless -c "TSInstallSync http json xml html graphql" -c "qa" || true

# Create entrypoint script
RUN echo '#!/bin/bash\n\
\n\
# Check if file path is provided\n\
if [ $# -eq 0 ]; then\n\
    echo "Usage: docker run --rm -v /path/to/files:/workspace kulala-nvim <http-file>"\n\
    exit 1\n\
fi\n\
\n\
# Get the file path\n\
FILE_PATH="$1"\n\
shift\n\
\n\
# If file path doesn'\''t start with /, assume it'\''s in /workspace\n\
if [[ "$FILE_PATH" != /* ]]; then\n\
    FILE_PATH="/workspace/$FILE_PATH"\n\
fi\n\
\n\
# Check if file exists\n\
if [ ! -f "$FILE_PATH" ]; then\n\
    echo "File not found: $FILE_PATH"\n\
    exit 1\n\
fi\n\
\n\
# Run kulala CLI or open nvim with the file\n\
if [ -f /root/.local/share/nvim/site/pack/kulala/start/kulala.nvim/lua/cli/kulala_cli.lua ]; then\n\
    # Use Kulala CLI if available\n\
    cd "$(dirname "$FILE_PATH")"\n\
    /root/.local/share/nvim/site/pack/kulala/start/kulala.nvim/lua/cli/kulala_cli.lua "$FILE_PATH" "$@"\n\
else\n\
    # Fallback to opening nvim\n\
    nvim "$FILE_PATH"\n\
fi\n\
' > /usr/local/bin/kulala-run.sh

# Make entrypoint executable
RUN chmod +x /usr/local/bin/kulala-run.sh

# Set working directory
WORKDIR /workspace

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/kulala-run.sh"]