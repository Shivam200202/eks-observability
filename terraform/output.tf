output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.zoop_cluster.endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.zoop_cluster.name
}

output "bastion_public_ip" {
    description = "Public IP of the Bastion Host"
    value = aws_instance.zoop_bation_instance.public_ip
  
}