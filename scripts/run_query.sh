#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -f "$PROJECT_ROOT/.env" ]; then
  export $(grep -v '^#' "$PROJECT_ROOT/.env" | xargs)
fi

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="./psql_$TIMESTAMP.log"


psql \
  -X \
  -v ON_ERROR_STOP=1 \
  -a \
  "$@" 2>&1 | tee "$LOG_FILE"