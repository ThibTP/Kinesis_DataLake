import boto3

glue = boto3.client('glue')

response = glue.create_crawler(
    Name='event-data-crawler',
    Role='arn:aws:iam::account-id:role/service-role/AWSGlueServiceRole-MyCrawlerRole',
    DatabaseName='event_database',
    Targets={
        'S3Targets': [
            {
                'Path': 's3://babbel_bucket/events/',
            },
        ]
    },
    TablePrefix='event_data'
)

response = glue.start_crawler(
    Name='event-data-crawler'
)
