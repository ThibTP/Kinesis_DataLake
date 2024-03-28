The aim of this project is to build a scalable data processing pipeline on AWS handling a high volume of events from a Kinesis Stream.
The architecture of this project is the following: 
![image](https://github.com/ThibTP/Kinesis_DataLake/assets/115563685/f7ec7353-9e8a-47d7-a91a-0a2535b9e922)

It consists of:
- Setting-up the Kinesis Stream to receive incoming events and to dynamically adjust the capacities based on workload demands - involves shard configuration to handle the expected throughput and setting-up autoscaling to adjust the number of shard in the stream
- Using AWS lambda functions to process events from the Kinesis Stream. Lambda functions are parsing JSON events, extracting required fields, and transforming them according to the project requirements. They also implement a logic to handle duplicate events
- Amazon S3 is used as a Data Lake and provides scalable and durable storage. The data is stored in a JSON format and partitioned based on timestamp. A folder structure in S3 is created based on the event creation date as well.
- AWS Glue for schema evolution and data cataloging - if schema changes are frequent

Furthermore, the following have been implemented to ensure the reliability, scalability and replicability of the architecture :
- Unit test for the lambda functions
- Integration test to validate the end-to-end data processing pipeline
- Using Terraform to replicate the architecture across environments
- Handling fluctuations in event volume by enabling autoscaling for Lambda functions and Kinesis stream.


  Technologies chosen and why:

  - Amazon Kinesis: Used for real-time data streaming and processing. It enables ingesting and processing large data streams in real-time. The integration with lambda functions is very easy. Finally it provides scalability, durability, and low-latency event processing capabilities.
  - AWS Lambda: It is a serverless compute service that allows to run code without provisioning or managing servers. It automatically scales based on the number of incoming events and charges only for the compute time consumed. It's been chosen for event processing due to its scalability, cost-effectiveness, and ease of integration with other AWS services like Kinesis and S3.
  - Amazon S3: It is an object storage service that offers scalable storage for data of any size. It provides high durability, availability, and security for storing and retrieving data. It is used to store processed events in an organized manner. It offers cost-effective, durable storage with easy integration with the other AWS services used in this project.
  - AWS Glue: It is chosen for its fully managed ETL capabilities, which streamline data processing tasks such as schema evolution, data cataloging, and automated data transformation. Its seamless integration with other AWS services used here and its serverless architecture make it a cost-effective and scalable solution for building and managing the data processing pipeline in the AWS cloud.

  Answer to design questions:

● How would you handle duplicate events?

Within the Lambda function, we implement a logic to handle duplicate events - we store the processed event UUIDs and if one has already been processed, an error message is thrown.

● How would you partition the data to ensure good querying performance and scalability?

We partition the data based on timestamp - we also create a folder structure in S3 based on the event creation date. This promotes good querying performance and scalability.

● What format would you use to store the data?

JSON due to flexibility and ease of use.

● How would you test the different components of your proposed architecture?

By setting-up an Integration test to validate the end-to-end data processing pipeline (from event ingestion to data storage in S3). Additionally by implementing a Unit test of the Lambda functions.

● How would you ensure the architecture deployed can be replicable across environments?

By using IaC like Terraform. 

● Would your proposed solution still be the same if the amount of events is 1000 times smaller or bigger?

Yes, as the architecture has been designed to cope with fluctuations in event volume by enabling autoscaling in the Terraform files for lambda functions and Kinesis stream. This way the number of shards in the Kinesis stream or the scaling configuration of the Lambda functions become dynamic. 

● Would your proposed solution still be the same if adding fields / transforming the data is no longer
needed?

The core components of the architecture would remain intact but the lambda functions would be streamlined - the data transformation logic would be revisited accordingly. Only one file would be impacted.  
