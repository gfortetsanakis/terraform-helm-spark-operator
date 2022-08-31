# Terraform module for spark operator

This module deploys a spark operator service on an Amazon EKS cluster. The module creates a service account for the spark operator configured with an IAM role which provides access to two S3 buckets, one for reading and writing data and one for writing event logs. All spark applications submitted with the service account of the spark operator will have access to the above buckets.

The module also deploys a spark history server on the cluster from which the logs of completed spark applications will be accessible.

## Module input parameters

| Parameter          | Type     | Description                                                                                    |
| ------------------ |--------- | ---------------------------------------------------------------------------------------------- |
| namespace                   | Required | The kubernetes namespace at which the spark operator chart will be deployed           |
| domain                      | Required | The domain of the EKS cluster                                                         |
| certificate_issuer          | Required | The name of the certificate issuer that will be used to issue certificates for spark applications |
| openid_connect_provider_arn | Required | The ARN of the OpenID connect provider of the cluster                                 |
| openid_connect_provider_url | Required | The URL of the OpenID connect provider of the cluster                                 |
| history_server_spark_image  | Required | The spark image used for deploying the spark history server on the cluster            |
| spark_data_bucket_name      | Required | The name of the S3 bucket at which spark will read and write data                     |
| history_server_spark_image  | Required | The spark image used for deploying the spark history server on the cluster            |
| spark_logs_bucket_name      | Required | The name of the S3 bucket at which logs of executed spark applications will be stored |
| spark_namespace             | Optional | An optional namespace to be created for deploying spark application in the cluster. If not specified a default namespace named "spark" will be created |
| node_selector               | Optional | A map variable with nodeSelector labels applied when placing pods of the chart on the cluster |


## Module output parameters

| Parameter              | Description                                                    |
| ---------------------- | -------------------------------------------------------------- |
| spark_service_account  | The name of the service account created for the spark operator |