variable "vpc_cidr_block" {
  description = "giving cidr"
  default = "190.20.60.0/24"
}
variable "public_subnet" {
  description = "cidr"
  default = "190.20.60.0/25"
}
variable "private_subnet" {
  description = "cidr"
  default = "190.20.60.128/25"
}
variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["ap-southeast-1a", "ap-southeast-1b"]
}
variable "Igw" {
  default = "0.0.0.0/0"
}
variable "amis" {
  type = map
  default = {
    "ap-southeast-1" = "ami-02045ebddb047018b"
  }
}
variable "region" {
  default = "ap-southeast-1"
}
variable "instance_count" {
  default = ["2" , "2"]
}

variable "instance_type" {
   default = "public_instance"
}
