terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  skip_requesting_account_id  = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  access_key                  = "not-necessary-for-localstack"
  secret_key                  = "not-necessary-for-localstack"

  endpoints {
    iam            = local.awsEndpoint
    lambda         = local.awsEndpoint
    sqs            = local.awsEndpoint
  }
}

module "traffic" {
  source          = "../modules/traffic"
  environment     = local.environment
}
