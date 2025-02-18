# How to ingest FHV 2019 data

## 1. Set Up Environment:
Copy .env.example to .env, fill in your sensitive information, and source it:

```
cp .env.example .env
source .env
```

## 2. Download Data Files:

```
chmod +x download_files.sh
./download_files.sh
```

## 3. Upload Files to GCS:

```
chmod +x upload_to_gcs.sh
./upload_to_gcs.sh
```

## 4. Create the BigQuery Table:

```
chmod +x create_bigquery_table.sh
./create_bigquery_table.sh
```
