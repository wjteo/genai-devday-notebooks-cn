# Single-container image bundling MongoDB Atlas Local (mongod + mongot, for
# Atlas/Vector Search support) together with a Jupyter environment, so the
# devcontainer runs as one container instead of docker-compose services.
# This is required for environments like Tencent Cloud Studio that only
# support a single-container devcontainer.
#
# The mongodb-atlas-local base image is a stripped-down UBI9-minimal image
# with no package manager binary at all (no dnf/microdnf/curl/tar), so Python
# is fetched as a portable "python-build-standalone" build in a separate
# builder stage and just copied in.
FROM debian:bookworm-slim AS python-builder
ARG TARGETARCH
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*
RUN set -eux; \
    case "${TARGETARCH}" in \
      amd64) PBS_ARCH=x86_64-unknown-linux-gnu ;; \
      arm64) PBS_ARCH=aarch64-unknown-linux-gnu ;; \
      *) echo "unsupported arch: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    URL=$(curl -fsSL https://api.github.com/repos/astral-sh/python-build-standalone/releases/latest \
      | grep -o "\"browser_download_url\": *\"[^\"]*cpython-3\.11\.[0-9]*[^\"]*-${PBS_ARCH}-install_only\.tar\.gz\"" \
      | head -1 | sed -E 's/.*"(https[^"]+)"/\1/'); \
    test -n "$URL"; \
    echo "Downloading $URL"; \
    curl -fsSL "$URL" -o /tmp/python.tar.gz; \
    mkdir -p /opt; \
    tar -xzf /tmp/python.tar.gz -C /opt; \
    rm /tmp/python.tar.gz

FROM mongodb/mongodb-atlas-local:latest

USER root

COPY --from=python-builder /opt/python /opt/python
RUN ln -s /opt/python/bin/python3 /usr/local/bin/python3 \
    && ln -s /opt/python/bin/python3 /usr/local/bin/python \
    && ln -s /opt/python/bin/pip3 /usr/local/bin/pip3 \
    && ln -s /opt/python/bin/pip3 /usr/local/bin/pip

# Create the non-root dev user devcontainers/Cloud Studio expects. uid 1000
# is already taken by the "mongod" user baked into this base image, so use
# 1001 instead. useradd/groupadd are already present in this base image.
RUN useradd -m -u 1001 -s /bin/bash vscode

RUN mkdir -p /workspaces && chown -R vscode:vscode /workspaces

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir jupyterlab notebook -r /tmp/requirements.txt

COPY .devcontainer/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

ENV MONGODB_INITDB_ROOT_USERNAME=admin \
    MONGODB_INITDB_ROOT_PASSWORD=mongodb

EXPOSE 8888 27017

WORKDIR /workspaces

CMD ["/usr/local/bin/start.sh"]
