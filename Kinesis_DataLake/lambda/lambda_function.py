import json
import boto3
from datetime import datetime

s3 = boto3.client('s3')


def lambda_handler(event, context):
    try:
        # Set to store processed event UUIDs
        processed_event_uuids = set()

        for record in event['Records']:
            payload = json.loads(record['kinesis']['data'])
            # Extracting required fields
            event_uuid = payload['event_uuid']
            event_name = payload['event_name']
            created_at = payload['created_at']
            # Transforming data
            created_datetime = datetime.datetime.utcfromtimestamp(created_at).isoformat()
            event_type, event_subtype = event_name.split(':')[:2]

            # Checking if event_uuid is already processed
            if event_uuid not in processed_event_uuids:
                # Storing processed event in S3
                s3.put_object(
                    Bucket='babbel_bucket',
                    Key=f'events/{event_type}/{created_datetime}/{event_uuid}.json',
                    Body=json.dumps(payload)
                )
                # Adding event_uuid to the set of processed event UUIDs
                processed_event_uuids.add(event_uuid)
            else:
                print(f"Duplicate event detected with UUID: {event_uuid}")
    except Exception as e:
        # Loging error message
        print(f"Error processing event: {e}")
