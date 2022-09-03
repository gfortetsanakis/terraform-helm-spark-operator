locals {
  openid_connect_provider_url = replace(var.eks_cluster_properties["openid_connect_provider_url"], "https://", "")
  openid_connect_provider_arn = var.eks_cluster_properties["openid_connect_provider_arn"]

  s3_buckets = {
    spark_logs_bucket = "spark-lab-events-logs-bucket"
    spark_data_bucket = "spark-lab-data-warehouse-bucket"
  }
}