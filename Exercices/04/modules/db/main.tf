resource "aws_security_group" "sg_mysql" {
  name = "${var.prefix}-${var.env}-sec-grp-mysql"
  description = "Security Group ssh"
  vpc_id = var.vpc_id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "this" {
  count = length(var.private_subnets)
  instance_class = var.instance_class
  db_name = "${var.prefix}-${var.env}-${var.db_name}-${count.index + 1}"
  engine = "mysql"
  engine_version = "8.0"
  username = var.db_username
  password = var.db_password
  allocated_storage = 10
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet_grp.name
  vpc_security_group_ids = [aws_security_group.sg_mysql.id, var.sg_ssh_id]
}

resource "aws_db_subnet_group" "db_subnet_grp" {
  subnet_ids = var.private_subnets
  name = "${var.prefix}-${var.env}-db-subnet-group"
}