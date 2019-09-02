
provider "aws" {
  region = "ap-northeast-1"
}

variable "env" {}

variable "example_instance_type" {
  default = "t2.micro"
}
locals {
  example_instance_type = "t3.micro"
}


resource "aws_instance" "example" {
  ami           = "ami-0c3fd0f5d33134a76"
  instance_type = var.env == "prod" ? "t3.micro" : "t2.micro"
  tags = {
    Name = "example"
  }
  user_data = <<EOF
  #!/bin/bash
  yum install -y httpd
  systemctl start httpd.service
  EOF
  subnet_id = "subnet-03a8d8e7a42401ef3"
}
