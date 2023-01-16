output "vpc_id" {
  value = aws_vpc.AWS-VPC.id
}

output "subnet_id" {
  value = aws_subnet.AWS-subnet.id
}

output "vpc_tenancy" {
  value = aws_vpc.AWS-VPC.instance_tenancy
}