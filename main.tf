# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
data "aws_region" "current" {}

resource "aws_eip" "main" {}

data "template_file" "main" {
  template = "${file("${path.module}/cloud-config.yml")}"

  vars {
    authorized_keys = "${jsonencode(var.authorized_keys)}"
    aws_region      = "${data.aws_region.current.name}"
    elastic_ip      = "${aws_eip.main.public_ip}"
    pem_bucket      = "${var.pem_bucket}"
    pem_path        = "${var.pem_path}"
  }
}

data "aws_iam_policy_document" "permissions" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:AssociateAddress",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = ["arn:aws:s3:::${var.pem_bucket}/${var.pem_path}"]
  }
}

module "asg" {
  source  = "telia-oss/asg/aws"
  version = "0.1.0"

  name_prefix     = "${var.name_prefix}-bastion"
  user_data       = "${data.template_file.main.rendered}"
  vpc_id          = "${var.vpc_id}"
  subnet_ids      = "${var.subnet_ids}"
  min_size        = "1"
  max_size        = "1"
  instance_type   = "${var.instance_type}"
  instance_ami    = "${var.instance_ami}"
  instance_key    = ""
  instance_policy = "${data.aws_iam_policy_document.permissions.json}"
  tags            = "${var.tags}"
}

resource "aws_security_group_rule" "ingress" {
  security_group_id = "${module.asg.security_group_id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["${var.authorized_cidr}"]
}
