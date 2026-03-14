#!/bin/bash
set -e

IMAGE="claude-code"

# Build image if not exists or --rebuild flag is passed
if [[ "$1" == "--rebuild" ]]; then
    docker build --no-cache -t "$IMAGE" "$(dirname "$0")"
    shift
elif ! docker image inspect "$IMAGE" &>/dev/null; then
    docker build -t "$IMAGE" "$(dirname "$0")"
fi

docker run -it --rm \
    --security-opt label=disable \
    -v "$(pwd):/workspace" \
    -v "$HOME:$HOME" \
    -e HOME="$HOME" \
    -e TERM="$TERM" \
    -e HOST_USER="$(id -un)" \
    "$IMAGE" "$@"
