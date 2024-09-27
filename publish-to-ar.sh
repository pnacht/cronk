set -eu

pip install -U \
    keyring \
    twine \
    setuptools \
    wheel > /dev/null
pip install -U keyrings.google-artifactregistry-auth > /dev/null

if ! gcloud auth application-default print-access-token --quiet > /dev/null; then
    gcloud auth application-default login
fi

python3 -m build --wheel

twine upload \
    --repository-url https://us-central1-python.pkg.dev/oss-exit-gate-dev/cronk--testpypi \
    --verbose \
    dist/*
