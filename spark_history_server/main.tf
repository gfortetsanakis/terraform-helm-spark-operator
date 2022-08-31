resource "kubectl_manifest" "spark-history-server-config" {
  yaml_body = templatefile("${path.module}/templates/spark-history-server-config.yaml", {
    spark_namespace       = var.spark_namespace
    spark_service_account = var.spark_service_account
  })
}

resource "kubectl_manifest" "spark-history-server-deployment" {
  yaml_body = templatefile("${path.module}/templates/spark-history-server-deployment.yaml", {
    spark_namespace              = var.spark_namespace
    spark_service_account        = var.spark_service_account
    node_selector                = var.node_selector
    history_server_spark_image   = var.history_server_spark_image
    spark_logs_bucket_name = var.spark_logs_bucket_name
  })

  depends_on = [kubectl_manifest.spark-history-server-config]
}

resource "kubectl_manifest" "spark-history-server-svc" {
  yaml_body = templatefile("${path.module}/templates/spark-history-server-svc.yaml", {
    spark_namespace = var.spark_namespace
  })

  depends_on = [kubectl_manifest.spark-history-server-deployment]
}

resource "kubectl_manifest" "spark-history-server-ingress" {
  yaml_body = templatefile("${path.module}/templates/spark-history-server-ingress.yaml", {
    spark_namespace    = var.spark_namespace
    certificate_issuer = var.certificate_issuer
    domain             = var.domain
  })

  depends_on = [kubectl_manifest.spark-history-server-svc]
}