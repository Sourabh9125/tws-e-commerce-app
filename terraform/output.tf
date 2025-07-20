output "region" {
  description = "value of the region"
  value       = local.region
}
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}
output "vpc_id" {
  description = "ID of the VPC created by the module"
  value       = module.vpc.vpc_id
}
output "eks_endpoint" {
  description = "EKS cluster endpoint for API access used by kubectl"
  value       = module.eks.cluster_endpoint

}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.my_instance.public_ip
}

# Output the public IP addresses of the EKS nodes
output "node_public_ips" {
  description = "Public IP addresses of the EKS nodes"
  value       = data.aws_instances.eks_nodes.public_ips
}

output "aws_caller_identity" {
  description = "AWS caller identity information"
  value       = data.aws_caller_identity.current
  
}