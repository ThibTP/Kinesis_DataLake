import unittest
import boto3
import time

class TestIntegration(unittest.TestCase):
    def setUp(self):
        # Initializing AWS clients
        self.kinesis_client = boto3.client('kinesis')
        self.s3_client = boto3.client('s3')

    def test_data_processing_pipeline(self):
        # Publishing test events to the Kinesis stream
        self.publish_test_events()

        # Waiting for Lambda functions to process events
        time.sleep(60)

        # Verifying that processed data is correctly stored in S3
        self.verify_processed_data_in_s3()

    def publish_test_events(self):
        # Publishing test events to the Kinesis stream
        test_event = {
            'event_uuid': '123',
            'event_name': 'account:created',
            'created_at': 1616161616
        }

        # Converting event payload to JSON
        test_event_json = json.dumps(test_event)

        # Publishing the test event to the Kinesis stream
        response = self.kinesis_client.put_record(
            StreamName='event-stream',
            Data=test_event_json,
            PartitionKey='partition_key'
        )

    def verify_processed_data_in_s3(self):
        # Verifying that processed data is correctly stored in S3
        response = self.s3_client.list_objects_v2(
            Bucket='babbel_bucket',
            Prefix='events/'
        )

        # Checking if the processed data object is present in the S3 bucket
        self.assertTrue('Contents' in response)
        self.assertTrue(len(response['Contents']) > 0)

if __name__ == '__main__':
    unittest.main()
