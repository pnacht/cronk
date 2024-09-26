set -eu

pip install -U keyring > /dev/null
pip install -U keyrings.google-artifactregistry-auth > /dev/null
pip install -U twine > /dev/null

if ! gcloud auth application-default print-access-token --quiet > /dev/null; then
    gcloud auth application-default login
fi

twine upload \
    --repository-url https://us-central1-python.pkg.dev/oss-exit-gate-dev/cronk--testpypi \
    --verbose \
    dist/*
