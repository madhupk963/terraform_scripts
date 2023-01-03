module "ec2_instance" {
  source     = "./Terraform-Tutorial/EC2withJenkins"

  region        = "us-east-1"
  key_name      = "my_keypair"
  instance_type = "t2.micro"

}
