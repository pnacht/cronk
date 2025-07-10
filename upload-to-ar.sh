#!/bin/bash
set -eu

VENV_DIR=".venv"
echo "Setting up virtual environment..."
if [ ! -d "$VENV_DIR" ]; then
  python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

echo "Build Package"
pip install -r .github/workflows/requirements/build.txt --require-hashes
python -m build

echo "Install release dependencies"
pip install -U keyring keyrings.google-artifactregistry-auth twine >/dev/null

echo "Gcloud login"
if ! gcloud auth application-default print-access-token --quiet >/dev/null; then
  gcloud auth application-default login
fi

echo "Upload"
twine upload \
  --verbose \
  --repository-url https://us-python.pkg.dev/oss-exit-gate-dev/cronk--testpypi \
  dist/*

echo "Publish script finished."
