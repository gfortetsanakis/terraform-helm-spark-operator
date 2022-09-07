# Terraform module for spark operator

This module deploys the following helm chart on an Amazon EKS cluster:

| Name           | Repository                                                  | Version |
| -------------- | ----------------------------------------------------------- | ------- |
| spark-operator | https://googlecloudplatform.github.io/spark-on-k8s-operator | 1.1.25  |

The module creates a service account for the spark operator configured with an IAM role with a policy that provides access to two S3 buckets, one for spark data and one for spark logs. All spark applications submitted with this service account will have access to the above buckets. The module also deploys a spark history server on the cluster from which the logs of completed spark applications will be accessible.

## Module input parameters

| Parameter                  | Type     | Description                                                                                                                              |
| -------------------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| namespace                  | Required | The kubernetes namespace on which the spark operator chart will be deployed                                                              |
| eks_cluster_properties     | Required | A map variable containing properties of the EKS cluster                                                                                  |
| domain                     | Required | The external DNS domain of the EKS cluster                                                                                               |
| certificate_issuer         | Required | The name of the certificate issuer that will be used to issue certificates for spark applications                                        |
| history_server_spark_image | Required | The spark image used for deploying the spark history server on the cluster                                                               |
| spark_data_bucket_name     | Required | The name of the spark data S3 bucket                                                                                                     |
| spark_logs_bucket_name     | Required | The name of the spark logs S3 bucket                                                                                                     |
| spark_namespace            | Optional | An optional namespace to be created for deploying spark applications. If not specified a default namespace named "spark" will be created |
| node_selector              | Optional | A map variable with nodeSelector labels applied when placing pods of the chart on the cluster                                            |

The structure of the "eks_cluster_properties" variable is as follows:

```
eks_cluster_properties = {
  openid_connect_provider_url = <URL of OpenID connect provider of EKS cluster>
  openid_connect_provider_arn = <ARN of OpenID connect provider of EKS cluster>  
}
```

## Module output parameters

| Parameter                | Description                                                                    |
| ------------------------ | ------------------------------------------------------------------------------ |
| spark_namespace          | The namespace created by the chart to be used for deploying spark applications |
| spark_service_account    | The name of the service account created for the spark operator                 |
| spark_history_server_url | The URL of the spark history server                                            |
