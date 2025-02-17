provider "aws" {
  region = local.region
}

locals {
  name            = "asiayo"
  cluster_version = "1.31"
  region          = "ap-northeast-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = "ap-northeast-1"

  tags = {
    Test       = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}


################################################################################
# EKS Module
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"
  
  cluster_name                   = local.name
  cluster_version                = local.cluster_version
  # cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["asiayo"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [cidrsubnet(local.vpc_cidr, 8, 0)]
  # public_subnets  = [cidrsubnet(local.vpc_cidr, 8, 1)]
  
  tags = local.tags
}