# -----------------------------------
# Read Replica for RDS
# -----------------------------------
resource "aws_db_instance" "read_replica" {
  identifier              = "rds-test-replica"
  replicate_source_db     = aws_db_instance.default.arn   # links to primary RDS
  instance_class          = "db.t3.micro"
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.sub-grp.id
  parameter_group_name    = "default.mysql8.0"

  # Optional: monitoring and performance settings
  monitoring_interval      = 60
  monitoring_role_arn      = aws_iam_role.rds_monitoring.arn

  # Backups not allowed on read replica (handled by source)
  skip_final_snapshot = true

  tags = {
    Name = "rds-read-replica"
    Role = "ReadReplica"
  }
}
