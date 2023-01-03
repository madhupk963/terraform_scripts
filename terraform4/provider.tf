terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region     = "ap-southeast-1"
}
provider "aws" {
  alias      = "singapore" 
  region     = "ap-southeast-1"
}
