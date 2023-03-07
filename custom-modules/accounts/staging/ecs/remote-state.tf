terraform {
  backend "s3" {
    bucket         = "marko-test-s3-remote-state"
    key            = "staging/ecs/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "marko-test-remote-state-locks"
    encrypt        = true
    profile        = "default"
  }
}