terraform {
  backend "s3" {
    bucket = "jenkins-server-bucket-4e6aeaee"
    key = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }

}
