provider "aws" {
  profile = "default"
  shared_credentials_file = "~/.aws/credentials"
  region = var.aws_region
  version = "~> 3.9"
}
data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
}

provider "http" {
  version = "~> 1.2"
}

