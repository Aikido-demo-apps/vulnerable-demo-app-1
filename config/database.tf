resource "aws_db_subnet_group" "default" {
  name        = "database-subnet-group"
  description = "Subnet group for database"
  subnet_ids  = [for db_subnet in aws_subnet.private: "${db_subnet.id}"]
}

resource "aws_db_instance" "default" {
    identifier            = "${var.aws_database_identifier}"
    allocated_storage     = 10
    max_allocated_storage = 20
    engine                = "postgres"
    engine_version        = "13.4"
    instance_class        = "db.t3.micro"

    storage_encrypted = false
  
    name     = "${var.aws_database_name}"
    username = "${var.aws_database_user}"
    password = "${var.aws_database_password}"
    port     = 5432
  
    db_subnet_group_name      = "${aws_db_subnet_group.default.id}"
    vpc_security_group_ids    = [aws_security_group.internal.id]

    maintenance_window = "Mon:00:00-Mon:03:00"
    backup_window      = "03:00-06:00"

    final_snapshot_identifier = "Ignore"
    backup_retention_period   = 0
    skip_final_snapshot       = true
    deletion_protection       = false
}