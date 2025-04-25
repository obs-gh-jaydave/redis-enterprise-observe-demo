#!/bin/bash
set -e
echo "Stopping and cleaning up..."
docker compose down --remove-orphans