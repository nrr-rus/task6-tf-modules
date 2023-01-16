variable "inst_type" {
  type = string
  description = "EC2 instance type"
  default = "t2.micro"
}

variable "public_ip_add" {
  type = bool
  description = "Associate Public IP address to EC2 instance"
  default = true
}

variable "ec2_vpc" {
  type = string
}

variable "ec2_subnet" {
  type = string
}

variable "ec2_sg" {
  type = string
}