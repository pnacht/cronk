#!/bin/bash

set -euo pipefail

cd $KOKORO_ARTIFACTS_DIR/git/cronk

echo "Installing dependencies..."
pip install -U \
    build \
    keyring \
    twine \
    setuptools \
    wheel \
    requests-toolbelt > /dev/null

pip install -U \
    keyrings.google-artifactregistry-auth > /dev/null

echo "Building..."
python3 -m build

echo "Uploading..."
twine upload \
    --repository-url "https://us-python.pkg.dev/oss-exit-gate-$ENV/cronk--$REGISTRY" \
    --verbose \
    dist/*

mv dist/* $KOKORO_ARTIFACTS_DIR/