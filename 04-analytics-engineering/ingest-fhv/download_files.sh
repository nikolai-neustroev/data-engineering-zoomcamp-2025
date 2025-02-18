#!/bin/bash
# download_files.sh
# Downloads 2019 FHV trip data files from GitHub releases.
# Requires: wget

set -euo pipefail

# Directory where files will be downloaded (defaults to 'fhv_2019_data')
DOWNLOAD_DIR="${DOWNLOAD_DIR:-fhv_2019_data}"
mkdir -p "${DOWNLOAD_DIR}"

BASE_URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv"

# Loop over months 01 to 12
for month in $(seq -w 01 12); do
    FILE="fhv_tripdata_2019-${month}.csv.gz"
    URL="${BASE_URL}/${FILE}"
    echo "Downloading ${FILE}..."
    wget -q --show-progress -P "${DOWNLOAD_DIR}" "${URL}"
done

echo "All files downloaded to ${DOWNLOAD_DIR}"
