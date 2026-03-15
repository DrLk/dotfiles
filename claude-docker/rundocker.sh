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

DOCKER_SOCK="${DOCKER_HOST#unix://}"
DOCKER_SOCK="${DOCKER_SOCK:-/var/run/docker.sock}"
if [[ ! -S "$DOCKER_SOCK" ]]; then
    DOCKER_SOCK="/var/run/docker.sock"
fi

docker run -it --rm \
    --security-opt label=disable \
    --privileged \
    --network=host \
    --device /dev/fuse \
    -u "$(id -u):$(id -g)" \
    --group-add "$(stat -c '%g' "$DOCKER_SOCK")" \
    -v "$(pwd):/workspace" \
    -v "$HOME:$HOME" \
    -v "$DOCKER_SOCK:/var/run/docker.sock" \
    -v /etc/passwd:/etc/passwd:ro \
    -v /etc/group:/etc/group:ro \
    -e HOME="$HOME" \
    -e TERM="$TERM" \
    -e HOST_USER="$(id -un)" \
    "$IMAGE" "$@"
