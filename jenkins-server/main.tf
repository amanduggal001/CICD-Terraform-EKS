#S3 Bucket
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "s3bucket" {
  bucket = "jenkins-server-bucket-${random_id.bucket_suffix.hex}"
}

#VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.azs.names
  public_subnets  = var.public_subnets
  enable_dns_hostnames = true
  map_public_ip_on_launch = true

  tags = {
    Name = "Jenkins VPC"
    Terraform = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "Jenkins Subnet"
  }
}

# Security Group
resource "aws_security_group" "jenkins_sg" {
  name        = "Jenkins-SecurityGroup"
  description = "Security group for Jenkins"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "Jenkins-SecurityGroup"
  }
}

resource "aws_security_group_rule" "ingress_http" {
  type            = "ingress"
  from_port       = 8080
  to_port         = 8080
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_sg.id
  description     = "HTTP"
}

resource "aws_security_group_rule" "ingress_ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_sg.id
  description     = "SSH"
}

resource "aws_security_group_rule" "egress" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_sg.id
}


# EC2

resource "aws_instance" "jenkins-server" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  availability_zone           = data.aws_availability_zones.azs.names[0]
  user_data                   = file("jenkins-install.sh")

  tags = {
    Name        = "Jenkins-Server-New"
    Terraform   = "true"
    Environment = "dev"
  }
}
