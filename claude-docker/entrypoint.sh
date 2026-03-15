#!/bin/bash
set -e

# In rootless Docker, UID 0 inside = host user outside.
# Running as non-root UID remaps through subuid and loses access to bind mounts.
export USER="$HOST_USER"
export LOGNAME="$HOST_USER"
export PATH="$HOME/.local/bin:$PATH"

# If called with flags but no command, prepend 'claude'
if [[ $# -gt 0 && "$1" == -* ]]; then
    set -- claude "$@"
fi

exec "$@"
