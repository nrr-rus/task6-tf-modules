resource "aws_instance" "EC2-instance" {
  ami           = "ami-0039da1f3917fa8e3"
   instance_type = "t2.micro"
  //instance_type = var.inst_type
  key_name      = "Task-5-keypair"
   associate_public_ip_address = true
  //associate_public_ip_address = var.public_ip_add
  tags = {
    Name = "EC2-TR-instance"
  }

  tenancy                     = var.ec2_vpc
  subnet_id                   = var.ec2_subnet
  vpc_security_group_ids      = [var.ec2_sg]
  user_data = file("../scripts/testscript2")

}