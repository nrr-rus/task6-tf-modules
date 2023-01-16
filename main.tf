terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.50.0"
    }
  }
}

provider "aws" {
  profile = "second"
  region  = "eu-central-1"
}


module "ec2_module" {
  source = "../modules/aws/ec2"
  ec2_vpc = module.vpc_module.vpc_tenancy
  ec2_subnet = module.vpc_module.subnet_id
  ec2_sg = module.sg_module.sg_id
}

module "sg_module" {
  source = "../modules/aws/securitygroup"
  vpc_bind = module.vpc_module.vpc_id
}

module "vpc_module" {
  source = "../modules/aws/vpc"
}

module "ec2_module_test" {
  source = "../modules/aws/ec2"
  ec2_vpc = module.vpc_module_test.vpc_tenancy
  ec2_subnet = module.vpc_module_test.subnet_id
  ec2_sg = module.sg_module_test.sg_id
}

module "sg_module_test" {
  source = "../modules/aws/securitygroup"
  vpc_bind = module.vpc_module_test.vpc_id
}

module "vpc_module_test" {
  source = "../modules/aws/vpc"
}

output "ec2_ip" {
  value = module.ec2_module.ec2_ip_address
}

output "ec2_ip_test" {
  value = module.ec2_module_test.ec2_ip_address
}



