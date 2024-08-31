# Provider Block
provider "aws" {
  # profile             = var.aws_profile
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]
  /*
  default_tags {
    tags = {
      Application      = "Cloud-Infra"
      Create_date_time = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
      Terraform        = "true"
      Team             = "Cloud-Architect-Group"
      Environment      = terraform.workspace
      Location         = "Frisco TX"
    }
  }
  */
}
