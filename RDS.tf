resource "aws_db_instance" "mysql-db" {
    allocated_storage       = 20
    db_name                 = local.db_name
    engine                  = "mysql"
    engine_version          = "5.7"
    instance_class          = "db.t3.micro"
    username                = local.db_username
    password                = local.db_password
    skip_final_snapshot     = true
    db_subnet_group_name    = aws_db_subnet_group.privatesubnet-mysql.name
    vpc_security_group_ids  = [aws_security_group.mysql-sg.id]
}

resource "local_file" "db_info" {
    content = <<EOF
DB Name: ${local.db_name}
DB User: ${local.db_username}
DB Pass: ${local.db_password}
DB Host: ${local.db_host}
EOF
    filename = "database-infos.txt"
}