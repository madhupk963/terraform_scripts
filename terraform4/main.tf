# aws_instance.import_inst:
resource "aws_instance" "import_inst" {
    ami                                  = "ami-02045ebddb047018b"
    associate_public_ip_address          = true
    availability_zone                    = "ap-southeast-1a"
    instance_type                        = "t2.micro"
    key_name                             = "my_vpcdemo_keypair"
    subnet_id                            = "subnet-0ff031324209c388b"
    tags                                 = {
        "Name" = "import_demo"
    }
    tags_all                             = {
        "Name" = "import_demo"
    }
    tenancy                              = "default"
    vpc_security_group_ids               = [
        "sg-05bb07d027b7c66d1",
    ]

    capacity_reservation_specification {
        capacity_reservation_preference = "open"
    }

    credit_specification {
        cpu_credits = "standard"
    }

    enclave_options {
        enabled = false
    }

    maintenance_options {
        auto_recovery = "default"
    }

}

# aws_s3_bucket.bucket:
resource "aws_s3_bucket" "bucket" {
    bucket                      = "madhusudhan-pk-bucket-1"
    versioning {
        enabled    = false
        mfa_delete = false
    }
}

# aws_vpc.import_demo_vpc:
resource "aws_vpc" "import_demo_vpc" {
    cidr_block                           = "200.30.40.0/24"
    tags                                 = {
        "Name" = "import_demo_vpc"
    }
}
