terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.50.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "nrr.tfstate.bucket"
    key    = "task6/terraform.tfstate"
    region = "eu-central-1"
    profile = "second"
  }
}

provider "aws" {
  profile = "second"
  region  = "eu-central-1"
}

resource "aws_instance" "EC2-instance" {
  ami           = "ami-0039da1f3917fa8e3"
  instance_type = "t2.micro"
  key_name      = "Task-5-keypair"

  tags = {
    Name = "EC2-TR-instance"
  }

  associate_public_ip_address = true
  tenancy                     = aws_vpc.AWS-VPC.instance_tenancy
  subnet_id                   = aws_subnet.AWS-subnet.id
  vpc_security_group_ids      = [aws_security_group.AWS-TR-SG.id]
  user_data = file("testscript2")

  /*user_data = <<EOF
#!/bin/bash
apt update -y
apt install -y nginx
EOF
*/
  

/*
  connection {
    type = "ssh"
    user = "ubuntu"
    # private_key = "${file/home/azuruser/task6/Task-5-keypair.pem}"
    private_key = file("/home/azuruser/task6/Task-5-keypair.pem")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh args",
    ]
  }

*/
 depends_on = [aws_vpc.AWS-VPC, aws_subnet.AWS-subnet]
}

resource "aws_vpc" "AWS-VPC" {
  cidr_block       = "10.90.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "AWS-TR-VPC"
  }

  lifecycle {
    ignore_changes = [cidr_block, instance_tenancy]
  }
}

resource "aws_subnet" "AWS-subnet" {
  vpc_id     = aws_vpc.AWS-VPC.id
  cidr_block = "10.90.90.0/24"

  tags = {
    Name = "AWS-subnet"
  }
}

resource "aws_route_table" "AWS-RouteTable" {
  vpc_id = aws_vpc.AWS-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.AWS-InternetGateway.id
  }
}

resource "aws_route_table_association" "assoc-1" {
  subnet_id      = aws_subnet.AWS-subnet.id
  route_table_id = aws_route_table.AWS-RouteTable.id
}


resource "aws_internet_gateway" "AWS-InternetGateway" {
  tags = {
    Name = "AWS-TR-Internet-Gateway"
  }

  vpc_id = aws_vpc.AWS-VPC.id
}

resource "aws_security_group" "AWS-TR-SG" {
  tags = {
    Name = "AWS-TR-SG"
  }

   dynamic "ingress" {
     for_each = ["22", "80", "8080"]
     content {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = ingress.value
      protocol    = "tcp"
      to_port     = ingress.value
     }
   }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  name   = "AWS-TR-Security-group"
  vpc_id = aws_vpc.AWS-VPC.id
}

output "ec2_ip_address" {
  value = aws_instance.EC2-instance.public_ip
  description = "Public IP on which Jenkins is running: "
}


