# Provider Block
provider "aws" {
  profile             = var.aws_profile
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]
  default_tags {
    tags = {
      Team        = "Cloud-Architect-Group"
      Environment = terraform.workspace
      Location    = "Frisco TX"
    }
  }
}
