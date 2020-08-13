output "private_ips" {
  value = module.instance.aws_instance_private_ips
}

output "admin_user" {
  value = var.admin_user
}

output "get_initial_admin_password" {
  value = format("aws --region %s ssm get-parameter --name %s --with-decryption", local.current_region, local.ssm_parameter_name)
}
