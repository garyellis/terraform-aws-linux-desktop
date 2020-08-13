# terraform-aws-linux-desktop
Run a linux desktop in AWS.

## Requirements
* AWS Marketplace subscription when using the default AMI Ubuntu Desktop 18.04 LTS (x86_64)
* Ubuntu Linux 18.04 based AMI

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_user | the linux desktop admin username | `string` | `"ubuntu"` | no |
| ami\_id | The AMI ID. Defaults to us-west-2 Ubuntu Desktop 18.04 LTS (x86\_64) | `string` | `"ami-05705aed6eb5b2574"` | no |
| disable\_api\_termination | protect from accidental ec2 instance termination | `bool` | `false` | no |
| ebs\_block\_device | additional ebs block devices | `list(map(string))` | `[]` | no |
| http\_proxy | the http proxy | `string` | `""` | no |
| https\_proxy | the https proxy | `string` | `""` | no |
| iam\_role\_policy\_attachments | A list of iam policies attached to the ec2 instance role | `list(string)` | `[]` | no |
| instance\_type | the aws instance type | `string` | `"t3.2xlarge"` | no |
| instances\_count | the number of linux desktop instances to launch | `number` | `1` | no |
| key\_name | The ec2 instance keypair name | `string` | `""` | no |
| name | the name common to all resources created by this module | `string` | n/a | yes |
| no\_proxy | the no proxy list | `string` | `""` | no |
| root\_block\_device | The root ebs device config | `list(map(string))` | <pre>[<br>  {<br>    "delete_on_termination": true,<br>    "encrypted": true,<br>    "volume_size": 120,<br>    "volume_type": "gp2"<br>  }<br>]</pre> | no |
| subnet\_id | the ec2 instance subnet | `string` | n/a | yes |
| tags | provide a map of aws tags | `map(string)` | `{}` | no |
| vpc\_id | the ec2 instance vpc id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| admin\_user | n/a |
| get\_initial\_admin\_password | n/a |
| private\_ips | n/a |
