#!/bin/bash
# upload_to_gcs.sh
# Uploads the downloaded 2019 FHV files to a Google Cloud Storage bucket.
# Requires: Google Cloud SDK (gsutil)
#
# Sensitive configuration such as BUCKET_NAME should be set via environment variables.

set -euo pipefail

# Check if BUCKET_NAME is set
if [ -z "${BUCKET_NAME:-}" ]; then
    echo "Error: BUCKET_NAME environment variable is not set."
    exit 1
fi

# Directory of downloaded files (defaults to 'fhv_2019_data')
DOWNLOAD_DIR="${DOWNLOAD_DIR:-fhv_2019_data}"

echo "Uploading files from ${DOWNLOAD_DIR} to gs://${BUCKET_NAME}/..."
gsutil cp "${DOWNLOAD_DIR}"/*.csv.gz gs://${BUCKET_NAME}/

echo "Upload complete."
