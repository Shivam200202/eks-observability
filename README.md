Amazon EKS Infrastructure with Terraform (zoop-cluster)
This repository contains the Infrastructure as Code (IaC) using Terraform to provision a fully functional, secure, and scalable Amazon Elastic Kubernetes Service (EKS) cluster on AWS, alongside a dedicated Bastion Host for secure cluster management.

🏗️ Architecture Overview
The infrastructure provisions the following AWS components:

Custom VPC: A dedicated 10.0.0.0/16 network isolated from default infrastructure.

Public Subnets: Two subnets spanning us-east-1a and us-east-1b tagged with Kubernetes ELB setup rules (kubernetes.io/role/elb = 1).

Bastion Host (EC2): A secure t2.micro Ubuntu instance sitting in the public subnet acting as the administrative gateway. It is pre-bootstrapped via user_data to install the AWS CLI, kubectl, and automatically inject the cluster's kubeconfig on startup.

EKS Control Plane: The managed Kubernetes master plane (zoop-cluster).

EKS Node Group: A managed worker node pool utilizing t2.medium instances with automated scaling configurations.

🛠️ Prerequisites
Before you start, ensure you have the following tools installed locally:

Terraform (v1.0+)

AWS CLI installed locally

An Amazon EC2 Key Pair named zoop-key created in your target region (us-east-1)

PowerShell (if executing the included authentication script)

⚙️ Configuration & Environment Variables
1. Terraform Variables (terraform.tfvars)
The infrastructure behavior can be adjusted by modifying variables in terraform.tfvars:

Terraform
aws_region      = "us-east-1"
cluster_name    = "zoop-cluster"
node_group_name = "zoop-node-group"
instance_type   = "t2.medium"
2. AWS Authentication Script (aws.ps1)
To authenticate your local deployment environment with AWS using PowerShell, a helper script is included. Update this file with your temporary AWS IAM credentials:

PowerShell
$env:AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID"
$env:AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"
⚠️ CRITICAL SECURITY NOTE: Never commit your actual AWS Access Keys to GitHub. Ensure aws.ps1 is added to your .gitignore file before pushing your code.

🚀 Deployment Guide
Follow these steps to initialize and spin up the infrastructure:

1. Clone & Navigate to Directory
PowerShell
git clone <your-repo-url>
cd DevOps/Terraform/EKS
2. Set Up AWS Credentials
Run the script to inject your AWS access tokens into your active PowerShell session:

PowerShell
.\aws.ps1
3. Initialize Terraform
Initialize the working directory to download the required AWS providers.

PowerShell
terraform init
4. Review Plan
Generate and review the execution plan to verify the AWS resources that will be built.

PowerShell
terraform plan
5. Apply Configuration
Provision the infrastructure. This process typically takes around 10 to 15 minutes while AWS spins up the managed EKS control plane.

PowerShell
terraform apply --auto-approve
🔓 Accessing the Cluster
Management of the cluster is routed securely through the Bastion Host.

Step 1: Get Bastion Connection Info
Once the apply finishes, capture the public IP of your bastion host from the Terraform outputs:

PowerShell
terraform output bastion_public_ip
Step 2: SSH Into the Bastion Host
Using your zoop-key.pem file, log into the provisioning server:

PowerShell
ssh -i "zoop-key.pem" ubuntu@<bastion_public_ip>
Step 3: Verify Pre-Installed Tools
The startup scripts automatically installed your dependencies and injected the EKS configuration into your environment. Verify interaction with your cluster by running:

Bash
# Check if nodes are ready and active
kubectl get nodes
🔒 Security Group Specifications
Bastion Host SG: Restricts inbound exposure exclusively to SSH port 22 from anywhere (0.0.0.0/0). (Note: For production environments, change cidr_blocks to your specific public IP).

Worker Nodes SG: Allows unhindered internal communication between nodes and the EKS control plane. Exposes NodePort ranges 30000-32767 to allow standard external access to application routing.

🧼 Cleanup
To wipe the slate clean and avoid recurring AWS charges for the EKS cluster, node groups, and EC2 instances, execute the destruction sequence:

PowerShell
terraform destroy --auto-approve

