# EKS Cluster Control Plane

resource "aws_eks_cluster" "zoop_cluster" {
  name  = var.cluster_name
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids = [
        aws_subnet.public_1.id,
        aws_subnet.public_2.id
    ]
  }

  depends_on = [ 
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
   ]
}

# EKS Worker Nodes

resource "aws_eks_node_group" "zoop_nodes" {
    cluster_name = aws_eks_cluster.zoop_cluster.name
    node_group_name = var.node_group_name
    node_role_arn = aws_iam_role.node_role.arn

    subnet_ids = [
        aws_subnet.public_1.id,
        aws_subnet.public_2.id
    ]

    instance_types = [var.instance_type]
    remote_access {
      ec2_ssh_key               = "zoop-key"
      source_security_group_ids = [aws_security_group.zoop_bastion_sg.id, aws_security_group.zoop_nodes_sg.id]
    }
    scaling_config {
      desired_size = 1
      max_size = 1
      min_size = 1
    }

    update_config {
      max_unavailable = 1
    }

    depends_on = [ 
        aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
        aws_iam_role_policy_attachment.amazon_eks_cni_policy,
        aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only
     ]
}