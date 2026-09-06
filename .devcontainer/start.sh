#!/bin/bash
set -e

# The base image's `su` binary is broken (missing libpam, since this is a
# stripped-down UBI9-minimal image), so use `setpriv` to drop privileges
# instead.

# Start MongoDB Atlas Local (mongod + mongot) in the background, as the
# "mongod" user the base image was built to run as.
setpriv --reuid=mongod --regid=mongod --init-groups /usr/local/bin/runner server &

echo "Waiting for MongoDB to accept connections on localhost:27017..."
until (echo > /dev/tcp/127.0.0.1/27017) 2>/dev/null; do
  sleep 1
done
echo "MongoDB is up."

# Run Jupyter in the foreground as the non-root dev user so the container
# keeps running and logs are visible.
cd /workspaces
export HOME=/home/vscode
exec setpriv --reuid=vscode --regid=vscode --init-groups \
  /opt/python/bin/jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --IdentityProvider.token=''
