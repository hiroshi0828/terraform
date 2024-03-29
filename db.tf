resource "aws_db_parameter_group" "example" {
  name   = "example"
  family = "mysql5.7"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

resource "aws_db_option_group" "example" {
  name                 = "example"
  engine_name          = "mysql"
  major_engine_version = "5.7"
}

resource "aws_db_subnet_group" "example" {
  name       = "example"
  subnet_ids = [aws_subnet.private_0.id, aws_subnet.private_1.id]
}

resource "aws_db_instance" "example" {
  identifier                 = "example"
  engine                     = "mysql"
  engine_version             = "5.7.23"
  instance_class             = "db.t2.small"
  allocated_storage          = 20
  storage_type               = "gp2"
  storage_encrypted          = true
  username                   = "hiroshi"
  password                   = "VeryStrongPassword!"
  multi_az                   = false
  publicly_accessible        = false
  auto_minor_version_upgrade = false
  deletion_protection        = false
  skip_final_snapshot        = true

  port              = 3306
  apply_immediately = false

  parameter_group_name = aws_db_parameter_group.example.name
  option_group_name    = aws_db_option_group.example.name
  db_subnet_group_name = aws_db_subnet_group.example.name

}

