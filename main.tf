/**
 * # AWS EKS Chartmuseum Terraform module
 *
 * A Terraform module to deploy the [Chartmuseum](https://chartmuseum.com/) on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-chartmuseum/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-chartmuseum/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-chartmuseum/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-chartmuseum/actions/workflows/pre-commit.yaml)
 */
locals {
  addon = {
    name = "chartmuseum"

    helm_chart_version = "3.9.1"
    helm_repo_url      = "https://chartmuseum.github.io/charts"
  }

  addon_irsa = {
    (local.addon.name) = {}
  }

  addon_values = yamlencode({
    serviceAccount = {
      create = var.service_account_create != null ? var.service_account_create : true
      name   = var.service_account_name != null ? var.service_account_name : local.addon.name
      annotations = module.addon-irsa[local.addon.name].irsa_role_enabled ? {
        "eks.amazonaws.com/role-arn" = module.addon-irsa[local.addon.name].iam_role_attributes.arn
      } : tomap({})
    }
  })

  addon_depends_on = []
}
