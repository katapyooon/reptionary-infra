terraform {
  backend "s3" {
    bucket  = "staging-reptionary-resource-tfstate"
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}
