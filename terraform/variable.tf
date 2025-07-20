variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
  default     = "t3.medium"

}
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}
variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 30

}
variable "env" {
  description = "Environment for the deployment (e.g., dev, prod)"
  type        = string
  default     = "prod"

}