# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "name_prefix" {
  description = "A prefix used for naming resources."
}

variable "vpc_id" {
  description = "The VPC ID."
}

variable "subnet_ids" {
  description = "ID of subnets where the bastion can be provisioned."
  type        = "list"
}

variable "authorized_keys" {
  description = "List of public keys which are added to bastion."
  type        = "list"
}

variable "authorized_cidr" {
  description = "List of CIDR blocks which can reach bastion on port 22."
  type        = "list"
}

variable "pem_bucket" {
  description = "S3 bucket where the PEM key is stored."
}

variable "pem_path" {
  description = "Path (bucket key) where the PEM key is stored."
}

variable "instance_type" {
  description = "Type of instance to provision."
  default     = "t2.micro"
}

variable "instance_ami" {
  description = "The EC2 image ID to launch."
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = "map"
  default     = {}
}
