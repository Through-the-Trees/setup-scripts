#! /usr/bin/env bash

REPO_URL="https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/refs/heads"
curl -s "$REPO_URL/_dev/run-scripts.sh" | bash || echo "Failed to run setup script!"