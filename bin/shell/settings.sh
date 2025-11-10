#! /usr/bin/env bash

export SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PROJECT_ROOT="$(cd "$SCRIPT_ROOT/.." && pwd)"
export TEMPLATES_ROOT="$PROJECT_ROOT/.config/setup"
