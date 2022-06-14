data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# data "aws_key_pair" "keypair" {
#   key_name = "kojitech_keypair"
# }

# we'll use data source to pull priv_subnet_id, pub_subnet

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["kojitechs_vpc"]
  }
}

# Pulling down priv_subnet 
data "aws_subnet_ids" "priv_subnet" {
  vpc_id = local.vpc_id
  filter {
    name   = "tag:Name"
    values = ["priv_*"]
  }
}

data "aws_subnet_ids" "pub_subnet" {
  vpc_id = local.vpc_id
  filter {
    name   = "tag:Name"
    values = ["pub_*"]
  }
}

# priv_subnet
data "aws_subnet" "priv_sub" {
  for_each = data.aws_subnet_ids.priv_subnet.ids
  id       = each.value

}

# public_subnet
data "aws_subnet" "public_sub" {
  for_each = data.aws_subnet_ids.pub_subnet.ids
  id       = each.value
}

data "aws_route53_zone" "mydomain" {
  name = lookup(var.d_name, terraform.workspace)
}