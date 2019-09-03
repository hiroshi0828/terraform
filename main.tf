
provider "aws" {
  profile = "user1"
  region  = "ap-northeast-1"
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
  user_data     = data.template_file.httpd_user_data.rendered
  tags = {
    Name = "example"
  }

  subnet_id = "subnet-03a8d8e7a42401ef3"
}
data "template_file" "httpd_user_data" {
  template = file("./user_data.sh.tpl")

  vars = {
    package = "httpd"
  }
}
