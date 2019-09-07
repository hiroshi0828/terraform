resource "aws_subnet" "private" {
  cidr_block              = "1.0.2.0/24"
  vpc_id                  = aws_vpc.example.id
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
