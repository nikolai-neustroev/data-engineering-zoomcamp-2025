import csv
import time
import json
from kafka import KafkaProducer

server = 'localhost:9092'
producer = KafkaProducer(
    bootstrap_servers=[server],
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

start_time = time.time()

with open('green_tripdata_2019-10.csv', 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        data = {
            # Provide a default timestamp if empty
            'lpep_pickup_datetime': row.get('lpep_pickup_datetime') or "1970-01-01 00:00:00",
            'lpep_dropoff_datetime': row.get('lpep_dropoff_datetime') or "1970-01-01 00:00:00",
            # Convert to int if possible, otherwise default to 0
            'PULocationID': int(row['PULocationID']) if row.get('PULocationID') and row['PULocationID'].strip() != "" else 0,
            'DOLocationID': int(row['DOLocationID']) if row.get('DOLocationID') and row['DOLocationID'].strip() != "" else 0,
            'passenger_count': int(row['passenger_count']) if row.get('passenger_count') and row['passenger_count'].strip() != "" else 0,
            # Convert to float if possible, otherwise default to 0.0
            'trip_distance': float(row['trip_distance']) if row.get('trip_distance') and row['trip_distance'].strip() != "" else 0.0,
            'tip_amount': float(row['tip_amount']) if row.get('tip_amount') and row['tip_amount'].strip() != "" else 0.0
        }
        producer.send('green-trips', value=data)

# Flush to ensure all messages are sent
producer.flush()

elapsed_time = time.time() - start_time
print(f"Time taken to send and flush dataset: {elapsed_time:.2f} seconds")
