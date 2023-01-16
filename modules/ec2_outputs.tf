output "ec2_ip_address" {
  value = aws_instance.EC2-instance.public_ip
  description = "Public IP on which Jenkins is running: "
}

output "ec2_key" {
  value = aws_instance.EC2-instance.key_name
  description = "Use this key to connect with SSH: "
  sensitive = true
}