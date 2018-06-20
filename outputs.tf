# ------------------------------------------------------------------------------
# Output
# ------------------------------------------------------------------------------
output "ip" {
  description = "Contains the public IP address of the bastion."
  value       = "${aws_eip.main.public_ip}"
}

output "role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the instance role."
  value       = "${module.asg.role_arn}"
}

output "role_name" {
  description = "The name of the instance role."
  value       = "${module.asg.role_name}"
}

output "security_group_id" {
  description = "The ID of the security group."
  value       = "${module.asg.security_group_id}"
}
