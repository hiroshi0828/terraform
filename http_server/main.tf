variable "instance_type" {}

resource "aws_instance" "default" {
  ami = "ami-0f9ae750e8274075b"

  instance_type = var.instance_type
  subnet_id     = "subnet-03a8d8e7a42401ef3"
  user_data     = <<EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
EOF
}



output "public_dns" {
  value = aws_instance.default.public_dns
}

