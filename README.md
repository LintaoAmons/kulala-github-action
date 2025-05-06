<div align="center">

![Kulala Logo](logo.svg)

# kulala.nvim

[![Made with love](assets/badge-made-with-love.svg)](https://github.com/mistweaverco/kulala.nvim/graphs/contributors)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/mistweaverco/kulala.nvim?style=for-the-badge)](https://github.com/mistweaverco/kulala.nvim/releases/latest)
[![Discord](assets/badge-discord.svg)](https://discord.gg/QyVQmfY4Rt)

<p></p>

A fully-featured REST Client Interface for Neovim.

Kulala is swahili for "rest" or "relax".

It allows you to make HTTP requests from within Neovim, CLI and CI/CD pipelines.

Check our main [repo](https://github.com/mistweaverco/kulala.nvim) and [documentation](https://neovim.getkulala.net/docs/) for more information.

</div>

# CLI and CI

The Kulala CLI is a command-line interface that allows you to execute HTTP files from the command line. 

It can be used standalone or as part of a CI/CD pipeline, effectively turning your HTTP files into an API test suite.

## Requirements

Kulala CLI requires Neovim (nvim) and curl to be present on your PATH. 

Optionally, grpcurl (for GRPC), websocat (for Websockets), jq (for JSON formatting) and nvim-treesitter for response highlighting may be installed.

## Configuration

The CLI comes with some sane defaults, but you can override them in `kulala.nvim/lua/cli/config.lua`.

## Kulala CLI

Usage: 

      Kulala CLI [--list] [--halt] [-m] [-h] 

      [-v {body,headers,headers_body,verbose,script_output,report}]

      [-e <env>] [-n <name> ...] [-l <line> ...]

      [<input>] ...

Arguments:

      input                      Path to folder or HTTP file/s
                            
Options:                    

      --list                     List requests in HTTP file
                                
      --name (-n) [<name>] ...   Filter requests by name
                                
      --line (-l) [<line>] ...   Filter requests by line #
                                
      --env (-e) <env>           Environment
                                
      --view (-v)                Response view
                                  {body,headers,headers_body,verbose,script_output,report}
                                
      --halt                     Halt on error
                                
      --mono (-m)                No color output
                                
      --help (-h)                Help

```bash
kulala_cli http_examples/cli.http -e prod -v report -n Login Request -l 15 20 
kulala_cli cli.http grpc.http
kulala_cli http_examples --list
```

## Kulala CI

Kulala provides a Github Action to run HTTP files as part of your CI/CD pipeline.

Example:
```yaml
---
name: main
on:
  pull_request: ~
jobs:
  build:
    name: Run HTTP tests
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Setup Kulala CI
        uses: mistweaverco/kulala-github-action@v1

      - name: Run Kulala CI
        run: |
          kulala_cli.lua http/cli.http
          kulala_cli.lua http -v report
        shell: bash
        env:
          COLUMNS: 120
```
