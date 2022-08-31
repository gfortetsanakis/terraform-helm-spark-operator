
variable "namespace" {
  description = "The kubernetes namespace at which the spark operator chart will be deployed."
}

variable "domain" {
  description = "The domain of the eks cluster."
}

variable "certificate_issuer" {
  description = "The name of the certificate issuer that will be used to issue certificates for spark applications running on the cluster."
}

variable "openid_connect_provider_arn" {
  description = "The ARN of the OpenID connect provider of the cluster"
}

variable "openid_connect_provider_url" {
  description = "The URL of the OpenID connect provider of the cluster"
}

variable "history_server_spark_image" {
  description = "The spark image used for deploying the spark history server on the cluster."
}

variable "spark_data_bucket_name" {
  description = "The name of the S3 bucket at which spark will read and write data."
}

variable "spark_logs_bucket_name" {
  description = "The name of the S3 bucket at which logs of executed spark applications will be stored."    
}

variable "spark_namespace" {
  description = "An optional namespace to be created for deploying spark application in the cluster. If not specified a default namespace named \"spark\" will be created."
  default = "spark"
}

variable "node_selector" {
  description = "A map variable with nodeSelector labels applied when placing pods of the chart on the cluster."
  default     = {}
}