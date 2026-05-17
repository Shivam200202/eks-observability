variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region for the services"
}

variable "cluster_name" {
    type    = string
    default = "zoop-cluster"
    description = "Cluster name for the EKS cluster"
}

variable "node_group_name" {
    type    = string
    default = "zoop-node-group"
    description = "Cluster name for the EKS cluster"
}

variable "instance_type" {
    type = string
    default = "t2.medium"
}

variable "ami" {
    type = string
    default = "ami-091138d0f0d41ff90"
}