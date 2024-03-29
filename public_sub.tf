resource "aws_subnet" "public" {
  cidr_block = "1.0.1.0/24"
  tags = {
    Name = "public-sub1"
  }
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
  vpc_id                  = aws_vpc.example.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

