#!/usr/bin/env bash

set -euo pipefail

[ $# -eq 1 ] || { echo "Usage: $0 STACK"; exit 1; }

STACK="${1}"
BASE_IMAGE="heroku/${STACK/-/:}-build"
OUTPUT_IMAGE="foundry-test-${STACK}-2"

echo "Building buildpack on stack ${STACK}..."

docker build \
    --no-cache \
    --build-arg "BASE_IMAGE=${BASE_IMAGE}" \
    --build-arg "STACK=${STACK}" \
    -t "${OUTPUT_IMAGE}" \
    .

echo "Checking Foundry can start and aliases exist..."

TEST_COMMAND="forge --version"
docker run --rm -t "${OUTPUT_IMAGE}" bash -c "/app/.foundry/bin/${TEST_COMMAND}"

echo "Success!"
