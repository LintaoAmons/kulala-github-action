# Kulala CLI Docker Image

Run Kulala CLI in a Docker container with all dependencies pre-installed.

## Quick Start

### Build the Image

```bash
docker build -t kulala-cli .
```

### Run HTTP Files

```bash
# Run a single HTTP file
docker run --rm -v $(pwd):/workspace kulala-cli api.http

# Run with environment and report view
docker run --rm -v $(pwd):/workspace kulala-cli api.http -e prod -v report

# List all requests in a file
docker run --rm -v $(pwd):/workspace kulala-cli api.http --list

# Run specific request by name
docker run --rm -v $(pwd):/workspace kulala-cli api.http -n "Login Request"

# Run requests at specific line numbers
docker run --rm -v $(pwd):/workspace kulala-cli api.http -l 15 20

# Run all HTTP files in a directory
docker run --rm -v $(pwd):/workspace kulala-cli tests/
```

## Using Docker Compose

```yaml
version: '3.8'

services:
  kulala-cli:
    build: .
    image: kulala-cli:latest
    volumes:
      - ./:/workspace
    environment:
      - COLUMNS=120
    command: api.http -v report
```

Run with:
```bash
docker-compose run --rm kulala-cli
```

## Environment Variables

You can pass environment variables for your HTTP files:

```bash
docker run --rm \
  -v $(pwd):/workspace \
  -e API_KEY=your-key \
  -e BASE_URL=https://api.example.com \
  kulala-cli api.http
```

## CI/CD Integration

### GitHub Actions

```yaml
name: API Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Build Kulala Docker Image
        run: docker build -t kulala-cli .
      
      - name: Run API Tests
        run: |
          docker run --rm \
            -v ${{ github.workspace }}:/workspace \
            -e API_KEY=${{ secrets.API_KEY }} \
            kulala-cli tests/ -v report
```

### GitLab CI

```yaml
api-tests:
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build -t kulala-cli .
    - docker run --rm -v $(pwd):/workspace kulala-cli tests/ -v report
```

## Features Included

- **Neovim** with nvim-treesitter for syntax highlighting
- **HTTP Tools**: curl, grpcurl, websocat
- **Utilities**: jq, ripgrep, fd-find
- **Languages**: Node.js, Python3
- **Pre-configured** treesitter parsers for HTTP, JSON, XML, HTML, JavaScript, GraphQL

## Advanced Usage

### Custom Neovim Configuration

Mount a custom init.lua:

```bash
docker run --rm \
  -v $(pwd):/workspace \
  -v $(pwd)/custom-init.lua:/root/.config/nvim/init.lua \
  kulala-cli api.http
```

### Debugging

Run with verbose output:

```bash
docker run --rm -v $(pwd):/workspace kulala-cli api.http -v verbose
```

### Shell Access

For debugging or interactive use:

```bash
docker run --rm -it -v $(pwd):/workspace --entrypoint bash kulala-cli
```

## Tips

1. **Volume Mounting**: Always mount your HTTP files directory to `/workspace`
2. **Terminal Width**: Set `COLUMNS` environment variable for proper output formatting
3. **Colors**: Use `-m` flag to disable colors if needed
4. **Halt on Error**: Use `--halt` flag to stop execution on first error

## Troubleshooting

### Permission Issues

If you encounter permission issues with mounted volumes:

```bash
docker run --rm -v $(pwd):/workspace --user $(id -u):$(id -g) kulala-cli api.http
```

### Network Access

For accessing host services:

```bash
# Linux
docker run --rm --network host -v $(pwd):/workspace kulala-cli api.http

# Mac/Windows
docker run --rm -v $(pwd):/workspace kulala-cli api.http
# Use host.docker.internal instead of localhost in HTTP files
```