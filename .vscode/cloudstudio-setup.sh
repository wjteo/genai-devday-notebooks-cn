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

# Notebooks read MONGODB_URI/PROXY_ENDPOINT via os.environ.get(...). Jupyter
# kernels here are spawned by the editor's extension host, which starts
# before this script runs and does NOT re-source the shell profile per
# kernel -- so appending to ~/.zshrc/~/.bashrc (a prior attempt) never
# reaches the kernel. Write a .env file at the repo root instead: VS Code's
# Python extension (python.envFile, default "${workspaceFolder}/.env")
# injects it directly into any kernel/debug session it spawns.
cat > "$(dirname "$0")/../.env" <<EOF
MONGODB_URI=$MONGODB_URI
PROXY_ENDPOINT=$PROXY_ENDPOINT
EOF

# Kept for terminal-based work (e.g. running scripts directly, not through a
# notebook kernel), even though it doesn't reach Jupyter kernels.
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
echo "Wrote .env at the repo root. Restart your Jupyter kernel to pick up MONGODB_URI/PROXY_ENDPOINT."
