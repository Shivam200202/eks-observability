resource "aws_vpc" "eks_vpc" {

    cidr_block  =   "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "eks-custom-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.eks_vpc.id

    tags = {
      Name = "eks-igw"
    }
}

# Public Subnet

resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "eks-public-us-east-1a"
    "kubernetes.io/role/elb"     = "1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  

  tags = {
    Name                         = "eks-public-us-east-1b"
    "kubernetes.io/role/elb"     = "1"
  }
}

# Public Route Table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }

  tags = {
    Name = "eks-public-rt"
  }
}

# Route Table Associationsaction

resource "aws_route_table_association" "public_1" {
    subnet_id = aws_subnet.public_1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}


# Security Group for Bastion Host

resource "aws_security_group" "zoop_bastion_sg" {
  name        = "zoop-bastion-ssh-sg"
  description = "Allows SSH access to bastion host"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "zoop-bastion-sg"
  }
}



resource "aws_security_group" "zoop_nodes_sg" {
  name        = "zoop-nodes-cluster-sg"
  description = "Security group for all nodes in the zoop cluster"
  vpc_id      = aws_vpc.eks_vpc.id

  # internal communication between the nodes and the EKS control plane
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "zoop-nodes-sg"
  }
}