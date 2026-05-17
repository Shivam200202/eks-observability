# For Bastion EC2 Instance

resource "aws_instance" "zoop_bation_instance" {

    ami = var.ami
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_1.id
    vpc_security_group_ids = [aws_security_group.zoop_bastion_sg.id]
    associate_public_ip_address = true

    key_name = "zoop-key"
    
    user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y unzip curl

              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install

              # Installing kubectl
              curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


              echo "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}" >> /home/ubuntu/.bashrc
              EOF

    tags = {
      Name = "zoop-bastion-host"
    }
}