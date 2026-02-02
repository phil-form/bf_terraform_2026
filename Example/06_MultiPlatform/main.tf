provider "aws" {
  region = "us-east-1"

  access_key = "anaccesskey"
  secret_key = "asecretkey"
  s3_use_path_style = true
  skip_credentials_validation = true
  skip_metadata_api_check = true
  skip_requesting_account_id = true

  endpoints {
    ec2 = "http://localhost:4566"
  }
}

provider "google" {
  alias = "gcp"
  region = "us-central1"
  project = "my-gcp-project"
}

module "aws_main" {
  source = "./aws"
  env = "dev"
  providers = {
    aws = aws
  }
}

module "gcp_main" {
  source = "./gcp"
  providers = {
    google = google.gcp
  }
}