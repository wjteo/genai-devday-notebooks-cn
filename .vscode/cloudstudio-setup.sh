#!/bin/bash
set -e


# directConnection=true is required here: mongodb-atlas-local runs as a
# single-node replica set, so without it the driver "discovers" the replica
# set member's address from the server (its internal container hostname)
# and tries to reconnect there instead of localhost, which hangs until
# ServerSelectionTimeoutError once Jupyter is running outside this container.
MONGODB_URI="mongodb://admin:mongodb@localhost:27017/?directConnection=true&authSource=admin"
PROXY_ENDPOINT="https://vtqjvgchmwcjwsrela2oyhlegu0hwqnw.lambda-url.us-west-2.on.aws/"

# Start MongoDB Atlas Local (mongod + mongot, for Atlas/Vector Search) as a
# single container. Idempotent so re-running on workspace restart is safe.
if [ "$(docker ps -aq -f name=^mongodb-atlas-local$)" ]; then
  docker start mongodb-atlas-local >/dev/null 2>&1 || true
else
  docker run -d --name mongodb-atlas-local \
    -p 27017:27017 \
    -e MONGODB_INITDB_ROOT_USERNAME=admin \
    -e MONGODB_INITDB_ROOT_PASSWORD=mongodb \
    mongodb/mongodb-atlas-local:latest
fi

pip install -r requirements.txt

# Notebooks read MONGODB_URI/PROXY_ENDPOINT via os.environ.get(...), but this
# script's own env doesn't reach the Jupyter kernels/terminals Cloud Studio
# spawns later. Those inherit the login shell's profile instead, so append
# the exports there (idempotently) rather than relying on this process's env.
for profile in "$HOME/.zshrc" "$HOME/.bashrc"; do
  [ -f "$profile" ] || touch "$profile"
  if ! grep -q '^export MONGODB_URI=' "$profile" 2>/dev/null; then
    {
      echo ""
      echo "# Added by .vscode/cloudstudio-setup.sh for the GenAI devday workshop"
      echo "export MONGODB_URI=\"$MONGODB_URI\""
      echo "export PROXY_ENDPOINT=\"$PROXY_ENDPOINT\""
    } >> "$profile"
  fi
done

echo "MongoDB Atlas Local is running on localhost:27017."
echo "Open a NEW terminal (or restart your Jupyter kernel) to pick up MONGODB_URI/PROXY_ENDPOINT."
