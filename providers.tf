provider "aws" {
  profile = default
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

