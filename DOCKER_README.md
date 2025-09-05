# Kulala Docker Image

This Docker image packages Neovim with the Kulala plugin for executing HTTP requests from the command line.

## Build the Image

```bash
docker build -t kulala-nvim .
```

## Usage

### Basic Usage

Run an HTTP file from your local directory:

```bash
# Mount current directory and run a file
docker run --rm -v $(pwd):/workspace kulala-nvim example.http

# Run with specific options
docker run --rm -v $(pwd):/workspace kulala-nvim example.http -v headers_body

# List all requests in the file
docker run --rm -v $(pwd):/workspace kulala-nvim example.http --list

# Run specific request by name
docker run --rm -v $(pwd):/workspace kulala-nvim example.http -n "Get example"

# Run with environment variables
docker run --rm -v $(pwd):/workspace -e API_KEY=your_key kulala-nvim api.http
```

### Mount from Different Directory

```bash
# Mount a specific directory
docker run --rm -v /path/to/your/http/files:/workspace kulala-nvim test.http

# Use absolute path inside container
docker run --rm -v /path/to/files:/data kulala-nvim /data/test.http
```

### Available Options

- `--list` - List all requests in the HTTP file
- `-n <name>` - Filter requests by name
- `-l <line>` - Filter requests by line number
- `-e <env>` - Specify environment
- `-v <view>` - Response view (body, headers, headers_body, verbose, script_output, report)
- `--halt` - Stop on first error
- `-m` - Monochrome output (no colors)
- `-h` - Show help

### Examples

Test the included example file:

```bash
# Build the image
docker build -t kulala-nvim .

# Run the example
docker run --rm -v $(pwd):/workspace kulala-nvim example.http

# Run specific request
docker run --rm -v $(pwd):/workspace kulala-nvim example.http -n "Get example"

# View as report
docker run --rm -v $(pwd):/workspace kulala-nvim example.http -v report
```

### Interactive Mode

If you want to use Neovim interactively with Kulala:

```bash
docker run --rm -it -v $(pwd):/workspace kulala-nvim bash -c "nvim /workspace/example.http"
```

Inside Neovim:
- `<space>r` - Run the request under cursor
- `<space>ra` - Run all requests
- `<space>t` - Toggle view (body/headers/both)
- `<space>e` - Set environment

## Base Image

This image is based on `chn2guevara/nvim:stable` and includes:
- Neovim (stable)
- Kulala plugin
- nvim-treesitter with HTTP, JSON, XML, HTML, GraphQL parsers
- curl for making HTTP requests
- jq for JSON formatting

## Notes

- Files are expected to be mounted to `/workspace` directory
- The container runs as root user
- All Kulala configuration uses defaults
- The CLI tool is available at `/root/.local/share/nvim/site/pack/kulala/start/kulala.nvim/lua/cli/kulala_cli.lua`