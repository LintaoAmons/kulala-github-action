#!/bin/bash

# Check if arguments are provided
if [ $# -eq 0 ]; then
    echo "Usage: docker run --rm -v \$(pwd):/workspace kulala-cli <http-file> [options]"
    echo ""
    echo "Options:"
    echo "  --list                     List requests in HTTP file"
    echo "  -n, --name <name>          Filter requests by name"
    echo "  -l, --line <line>          Filter requests by line number"
    echo "  -e, --env <env>            Environment"
    echo "  -v, --view <view>          Response view (body|headers|headers_body|verbose|script_output|report)"
    echo "  --halt                     Halt on error"
    echo "  -m, --mono                 No color output"
    echo "  -h, --help                 Show help"
    echo ""
    echo "Examples:"
    echo "  docker run --rm -v \$(pwd):/workspace kulala-cli api.http"
    echo "  docker run --rm -v \$(pwd):/workspace kulala-cli api.http -e prod -v report"
    echo "  docker run --rm -v \$(pwd):/workspace kulala-cli tests/ --list"
    exit 1
fi

# Set COLUMNS for proper terminal output
export COLUMNS="${COLUMNS:-120}"

# Execute kulala CLI with all passed arguments
exec kulala_cli.lua "$@"