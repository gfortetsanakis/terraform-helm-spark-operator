locals {
  openid_connect_provider_url = replace(var.eks_cluster_properties["openid_connect_provider_url"], "https://", "")
  openid_connect_provider_arn = var.eks_cluster_properties["openid_connect_provider_arn"]

  s3_buckets = {
    spark_logs_bucket = var.spark_logs_bucket_name
    spark_data_bucket = var.spark_data_bucket_name
  }
}