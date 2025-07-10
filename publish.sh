set -eu

echo "Build Package"

pip install -r .github/workflows/requirements/build.txt --require-hashes
python -m build

echo "Install release dependencies"

pip install -U keyring > /dev/null
pip install -U keyrings.google-artifactregistry-auth > /dev/null
pip install -U twine > /dev/null

echo "Gcloud login"

if ! gcloud auth application-default print-access-token --quiet > /dev/null; then
    gcloud auth application-default login
fi

echo "Upload"

twine upload \
    --verbose \
    --repository-url https://us-python.pkg.dev/oss-exit-gate-dev/cronk--testpypi \
    dist/*

