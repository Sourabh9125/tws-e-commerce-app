data "aws_caller_identity" "current" {
    # This data source is used to get the current AWS account ID
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name                   = local.cluster_name
  cluster_endpoint_public_access = true
  

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.public_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # eks managed node groups

  eks_managed_node_group_defaults = {

    instance_types = ["t3.medium", "t3a.medium", "t2.medium"]
    attach_cluster_primary_security_group = true
    
  }


  eks_managed_node_groups = {

    cluster-ng = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium", "t3a.medium", "t2.medium"]
      capacity_type  = "SPOT"

      disk_size                  = 30
      use_custom_launch_template                 = false  # Important to apply disk size!

  


      tags = {
        Name = "cluster-ng"
        Environment = "prod"
        ExtraTag = "e-commerce-app"
      }
    }
  }  
     
    # Allow your IAM user access to EKS via aws-auth
  enable_cluster_creator_admin_permissions = true
  
  access_entries = {
    admin-user = {
      principal_arn = data.aws_caller_identity.current.arn
      type = "STANDARD"

      policy_associations = {
        cluster-admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"


          access_scope = {
          type       = "cluster"
          namespaces = []
        }
        }
      }
    }
    
  }
   
  tags = local.tags

}


# resource "aws_eks_access_entry" "eks_shop_cluster" {
#   cluster_name      = module.eks.cluster_name
#   principal_arn     = data.aws_caller_identity.current.arn
#   kubernetes_groups = ["system:masters"]
#   type              = "STANDARD"
# }

data "aws_instances" "eks_nodes" {
  instance_tags = {
    "eks:cluster-name" = module.eks.cluster_name
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [module.eks]
}

