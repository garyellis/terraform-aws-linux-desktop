variable "name" {}
variable "key_name" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "tags" { type = map(string) }

module "linux_desktop" {
  source = "../"

  name                        = var.name
  key_name                    = var.key_name
  iam_role_policy_attachments = []
  subnet_id                   = var.subnet_id
  vpc_id                      = var.vpc_id
  tags                        = var.tags

  http_proxy  = "http://squid-proxy.shared-services.ews.works:3128"
  https_proxy = "http://squid-proxy.shared-services.ews.works:3128"
  no_proxy    = "localhost,127.0.0.1,::1,169.254.169.254,169.254.170.2,ews.works"

}

output "private_ips" {
  value = module.linux_desktop.private_ips
}

output "admin_user" {
  value = module.linux_desktop.admin_user
}

output "get_initial_admin_password" {
  value = module.linux_desktop.get_initial_admin_password
}
