

resource "aws_db_instance" "db" {
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "9.6.20"
  instance_class       = "db.t2.micro"

  identifier = "database-2"

  name                 = "app"
  username             = "postgres"
  password             = "changeme"
  port     = "5432"

  vpc_security_group_ids = var.db_security_groups

  db_subnet_group_name = aws_db_subnet_group.default.name

  final_snapshot_identifier = "ci-aurora-cluster-backup"

  skip_final_snapshot  = true

  # publicly_accessible = true
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.subnets.*.id
}

output "db_adr" {
  value = aws_db_instance.db.address
}