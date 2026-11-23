#!/usr/bin/env bash
set -euo pipefail
# Print forbidden imports, if any. Must print nothing on success.
grep -R -n 'package:http' lib/features/*/screens lib/features/*/providers lib/core/widgets 2>/dev/null || true
