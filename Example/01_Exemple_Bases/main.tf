provider "aws" {
  region = "us-west-2"

  access_key                  = "test"
  secret_key                  = "test"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localhost:4566"
  }
}

resource "aws_instance" "example" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  tags = {
    Name = "example-terraform-1"
  }
}