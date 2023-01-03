terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "ap-south-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "mysubnet" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.0.0/24"
	tags = {
		Name = "subnet"
	}

}
