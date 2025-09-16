#!/usr/bin/env bash
set -e
mkdir -p /workspace/test/templates_c/v7 /workspace/test/vtlib/HTML
mkdir -p /workspace/cache /workspace/storage /workspace/logs /workspace/user_privileges
chmod -R 777 /workspace/test/templates_c /workspace/test/vtlib \
            /workspace/cache /workspace/storage /workspace/logs /workspace/user_privileges || true
