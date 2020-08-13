terraform {
  backend "s3" {
    bucket = "ews-works"
    key    = "github.com/garyellis/terraform-aws-linux-desktop/examples/terraform.tfstate"
    region = "us-west-2"
  }
}
