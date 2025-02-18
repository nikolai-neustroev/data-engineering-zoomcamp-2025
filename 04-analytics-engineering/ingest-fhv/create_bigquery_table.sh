#!/bin/bash
# create_bigquery_table.sh
# Creates a native BigQuery table by loading CSV data from GCS.
# Requires: BigQuery command-line tool (bq)
#
# The following environment variables must be set:
# - PROJECT_ID: Your GCP project ID
# - BQ_DATASET: The BigQuery dataset name
# - BQ_TABLE: The table name to create
# - BUCKET_NAME: The GCS bucket containing the CSV files

set -euo pipefail

# Verify that required environment variables are set
for var in PROJECT_ID BQ_DATASET BQ_TABLE BUCKET_NAME; do
    if [ -z "${!var:-}" ]; then
        echo "Error: $var environment variable is not set."
        exit 1
    fi
done

# Set your location; adjust if needed (e.g., if using a region other than US)
LOCATION="US"

# GCS URI using wildcard for all 2019 files
GCS_URI="gs://${BUCKET_NAME}/fhv_tripdata_2019-*.csv.gz"

echo "Loading data from ${GCS_URI} into BigQuery table ${PROJECT_ID}:${BQ_DATASET}.${BQ_TABLE}..."
bq --location=${LOCATION} load \
  --project_id=${PROJECT_ID} \
  --source_format=CSV \
  --autodetect \
  ${BQ_DATASET}.${BQ_TABLE} \
  ${GCS_URI}

echo "BigQuery table created successfully."
