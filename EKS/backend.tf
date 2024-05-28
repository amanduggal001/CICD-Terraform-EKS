terraform {
  backend "s3" {
    bucket = "jenkins-server-bucket-4e6aeaee"
    key = "eks/terraform.tfstate"
    region = "us-east-1"
  }

}
