# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the Kulala GitHub Action repository - a composite GitHub Action that sets up the Kulala CLI environment for running HTTP files in CI/CD pipelines. Kulala is a REST Client Interface for Neovim that allows making HTTP requests from within Neovim, CLI, and CI/CD pipelines.

## Key Components

- `action.yml` - Main GitHub Action definition file that orchestrates the setup of Neovim, nvim-treesitter, Node.js, and the Kulala CLI environment
- The action clones the main kulala.nvim repository and sets up the CLI tools in the GitHub Actions environment

## Dependencies and Setup

The action sets up the following dependencies:
1. Neovim (using rhysd/action-setup-vim@v1)
2. nvim-treesitter (cloned from nvim-treesitter/nvim-treesitter)
3. Node.js v22 (using actions/setup-node@v4)
4. Kulala.nvim (cloned from mistweaverco/kulala.nvim)

The CLI requires curl to be present on PATH. Optional dependencies include grpcurl (for GRPC), websocat (for Websockets), and jq (for JSON formatting).

## Testing the Action

To test changes to the action locally, you can:
1. Create a test workflow in `.github/workflows/` that uses the action with `uses: ./`
2. Use the action in other repositories by referencing `mistweaverco/kulala-github-action@v1`

## Important Notes

- The action symlinks nvim-treesitter to `$XDG_DATA_HOME` for proper Neovim integration
- The Kulala CLI path is added to GitHub PATH via `$KULALA_CLI_PATH`
- The action runs `kulala_ci.sh` to update/configure the CLI after setup
- When modifying `action.yml`, ensure all composite action steps maintain proper shell specifications