output "spark_namespace" {
  value = var.spark_namespace
}

output "spark_service_account" {
  value = "spark-operator-spark"
}

output "spark_history_server_url" {
  value = "https://spark.${var.domain}"
}