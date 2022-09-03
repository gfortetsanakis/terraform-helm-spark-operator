resource "aws_s3_object" "spark_logs_dir" {
  bucket = var.spark_logs_bucket_name
  key    = "logs/"
}

resource "kubernetes_namespace" "spark_namespace" {
  metadata {
    name = var.spark_namespace
  }
}

resource "aws_iam_policy" "spark_bucket_access_policy" {
  for_each    = local.s3_buckets
  name        = "${each.key}_access_policy"
  description = "IAM policy providing access to ${each.key}."

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {

        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${each.value}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::${each.value}"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "spark_s3_role" {
  name = "spark_s3_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${local.openid_connect_provider_arn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${local.openid_connect_provider_url}:sub" : "system:serviceaccount:${var.spark_namespace}:spark-operator-spark"
          }
        }
      }
    ]
  })

  tags = {
    "ServiceAccountName"      = "spark-operator-spark"
    "ServiceAccountNameSpace" = var.spark_namespace
  }

  managed_policy_arns = values(aws_iam_policy.spark_bucket_access_policy).*.arn
}

resource "helm_release" "spark-operator" {
  chart            = "spark-operator"
  name             = "spark-operator"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://googlecloudplatform.github.io/spark-on-k8s-operator"
  version          = "1.1.25"
  wait             = true

  values = [
    templatefile("${path.module}/templates/spark-operator.yaml", {
      spark_namespace   = var.spark_namespace
      domain            = var.domain
      node_selector     = var.node_selector
      spark_s3_role_arn = aws_iam_role.spark_s3_role.arn
    })
  ]

  depends_on = [kubernetes_namespace.spark_namespace]
}

module "spark_history-server" {
  source                     = "./spark_history_server"
  spark_namespace            = var.spark_namespace
  domain                     = var.domain
  node_selector              = var.node_selector
  spark_service_account      = "spark-operator-spark"
  history_server_spark_image = var.history_server_spark_image
  spark_logs_bucket_name     = var.spark_logs_bucket_name
  certificate_issuer         = var.certificate_issuer

  depends_on = [helm_release.spark-operator, aws_s3_object.spark_logs_dir]
}