provider "aws" {
  region = "eu-west-1"
}

data "aws_vpc" "main" {
  default = true
}

data "aws_subnet_ids" "main" {
  vpc_id = "${data.aws_vpc.main.id}"
}

module "bastion" {
  source = "../../"

  name_prefix   = "example"
  vpc_id        = "${data.aws_vpc.main.id}"
  subnet_ids    = ["${data.aws_subnet_ids.main.ids}"]
  pem_bucket    = "example-key-bucket"
  pem_path      = "example-key.pem"
  instance_ami  = "<ami-id>"
  instance_type = "t2.micro"

  authorized_keys = [
    "ssh-rsa <public-key>",
  ]

  authorized_cidr = [
    "0.0.0.0/0",
  ]

  tags {
    environment = "prod"
    terraform   = "True"
  }
}

output "bastion_ip" {
  value = "${module.bastion.ip}"
}
