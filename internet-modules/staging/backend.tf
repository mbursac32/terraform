# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "markob-test-tf-state"
    dynamodb_table = "test-lock-table"
    encrypt        = true
    key            = "./terraform.tfstate"
    region         = "eu-west-1"
  }
}
