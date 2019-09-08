variable "instance_type" {
  default = "t2.micro"
}


resource "aws_instance" "default" {
  ami           = "ami-0f9ae750e8274075b"
  instance_type = var.instance_type
  user_data     = <<EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
EOF
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "example"
  }
  key_name = "${aws_key_pair.key_pair.id}"
}

output "public_dns" {
  value = aws_instance.default.public_dns
}

