variable "name" {
  description = "the name common to all resources created by this module"
  type        = string
}

variable "instances_count" {
  description = "the number of linux desktop instances to launch"
  type        = number
  default     = 1
}

variable "ami_id" {
  description = "The AMI ID. Defaults to us-west-2 Ubuntu Desktop 18.04 LTS (x86_64)"
  type        = string
  default     = "ami-05705aed6eb5b2574"
}

variable "subnet_ids" {
  description = "the ec2 instance subnet ids"
  type        = list(string)
}

variable "private_ips" {
  description = "A list of private IPs associated to the EC2 instances. This length should be the instances count"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "the ec2 instance vpc id"
  type        = string
}

variable "instance_type" {
  description = "the aws instance type"
  type        = string
  default     = "t3.2xlarge"
}

variable "disable_api_termination" {
  description = "protect from accidental ec2 instance termination"
  type        = bool
  default     = false
}

variable "root_block_device" {
  description = "The root ebs device config"
  type = list(map(string))
  default = [
    {
      delete_on_termination = true
      volume_type           = "gp2"
      volume_size           = 120
      encrypted             = true
    }
  ]
}

variable "ebs_block_device" {
  description = "additional ebs block devices"
  type        = list(map(string))
  default     = []
}

variable "key_name" {
  description = "The ec2 instance keypair name"
  type        = string
  default     = ""
}

variable "iam_role_policy_attachments" {
  description = "A list of iam policies attached to the ec2 instance role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "provide a map of aws tags"
  type        = map(string)
  default     = {}
}

variable "admin_user" {
  description = "the linux desktop admin username"
  type        = string
  default     = "ubuntu"
}

variable "http_proxy" {
  description = "the http proxy"
  type        = string
  default     = ""
}

variable "https_proxy" {
  description = "the https proxy"
  type        = string
  default     = ""
}

variable "no_proxy" {
  description = "the no proxy list"
  type        = string
  default     = ""
}
