#!/bin/bash

set -euo pipefail

cd $KOKORO_ARTIFACTS_DIR/git/cronk

pip install -U \
    build \
    keyring \
    twine \
    setuptools \
    wheel > /dev/null

pip install -U \
    keyrings.google-artifactregistry-auth > /dev/null

python3 -m build --wheel

twine upload \
    --repository-url "https://us-python.pkg.dev/oss-exit-gate-$ENV/cronk--$REGISTRY" \
    --verbose \
    dist/*

mv dist/* $KOKORO_ARTIFACTS_DIR/