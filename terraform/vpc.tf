module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name            = "my-vpc"
  cidr            = local.cidr
  azs             = local.azs
  private_subnets = local.private_subnets
  # Public subnets for load balancers and NAT gateways
  public_subnets = local.public_subnets
  intra_subnets  = local.intra_subnets

  enable_nat_gateway = true


  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
  # Ensure public subnets auto-assign public IPs
  map_public_ip_on_launch = true
}