data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  name                 = format("%s-desktop", var.name)
  current_aws_account  = data.aws_caller_identity.current.account_id
  current_region       = data.aws_region.current.name

  ssm_parameter_path   = format("/terraform-aws-linux-desktop/%s", var.name)
  ssm_parameter_name   = format("%s/%s", local.ssm_parameter_path, "initial-admin-password")
  ssm_parameter_arn    = format("arn:aws:ssm:%s:%s:parameter%s", local.current_region, local.current_aws_account, local.ssm_parameter_name)
}

#### ssm parameters config
resource "random_password" "initial_admin_password" {
  length      = 26
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  special     = false
}

resource "aws_ssm_parameter" "initial_admin_password" {
  description = "The linux desktop initial admin password"
  name        = local.ssm_parameter_name
  type        = "SecureString"
  value       = random_password.initial_admin_password.result
  tags        = var.tags
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid = "SSMAccess"
    effect = "Allow"
    actions = [
      "ssm:*",
    ]
    resources = [
      local.ssm_parameter_arn
    ]
  }
}

data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "policy" {
  name_prefix = var.name
  policy      = data.aws_iam_policy_document.policy.json
}
####
resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.instance.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role_policy_attachment" "additional_policy_attachments" {
  count = length(var.iam_role_policy_attachments)

  role       = aws_iam_role.instance.name
  policy_arn = var.iam_role_policy_attachments[count.index]
}

resource "aws_iam_role" "instance" {
  name_prefix        = var.name
  description        = "linux desktop iam role"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
  tags               = var.tags
}

resource "aws_iam_instance_profile" "instance" {
  name_prefix = var.name
  role        = aws_iam_role.instance.name
}



module "sg" {
  source = "github.com/garyellis/tf_module_aws_security_group?ref=v0.2.1"

  create_security_group         = true
  description                   = format("%s security group", local.name)
  egress_cidr_rules             = []
  egress_security_group_rules   = []
  ingress_cidr_rules            = []
  ingress_security_group_rules  = []
  name                          = local.name
  tags                          = var.tags
  toggle_allow_all_egress       = true
  toggle_allow_all_ingress      = true
  toggle_self_allow_all_egress  = true
  toggle_self_allow_all_ingress = true
  vpc_id                        = var.vpc_id
}

module "userdata" {
  source = "github.com/garyellis/tf_module_cloud_init?ref=v0.2.5"

  base64_encode          = false
  gzip                   = false
  extra_user_data_script = templatefile("${path.module}/userdata.tmpl", {
    ssm_region           = local.current_region
    ssm_parameter_name   = local.ssm_parameter_name
    admin_user           = var.admin_user

    # workaround an ubuntu cloud-init env issue
    use_http_proxy       = var.http_proxy == "" ? "false" : "true"
  })

  install_http_proxy_env = var.http_proxy == "" ? false : true
  http_proxy             = var.http_proxy
  https_proxy            = var.https_proxy
  no_proxy               = var.no_proxy
}

module "instance" {
  source = "github.com/garyellis/tf_module_aws_instance?ref=v1.3.2"

  count_instances             = var.instances_count
  name                        = local.name
  ami_id                      = var.ami_id
  iam_instance_profile        = aws_iam_instance_profile.instance.name
  user_data                   = module.userdata.cloudinit_userdata
  instance_type               = var.instance_type
  disable_api_termination     = var.disable_api_termination
  key_name                    = var.key_name
  associate_public_ip_address = false
  security_group_attachments  = list(module.sg.security_group_id)
  subnet_ids                  = list(var.subnet_id)
  tags                        = var.tags

  root_block_device           = var.root_block_device
  ebs_block_device            = var.ebs_block_device

  instance_auto_recovery_enabled = true
}
