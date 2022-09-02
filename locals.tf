locals {
  openid_connect_provider_url = replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")
  openid_connect_provider_arn = data.aws_iam_openid_connect_provider.eks_cluster_oidc.arn
}