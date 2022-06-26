
locals {
  name            = "kojitechs-${replace(basename(var.component_name), "-", "-")}"
  database_subnet = [for i in data.aws_subnet.database_subnets : i.id]
}



data "aws_subnet_ids" "database_sub" {
  vpc_id = local.vpc_id
  filter {
    name   = "tag:Name"
    values = ["database_*"]
  }
}

# priv_subnet 
data "aws_subnet" "database_subnets" {
  for_each = data.aws_subnet_ids.database_sub.ids
  id       = each.value
}
#
# sg for database
resource "aws_security_group" "mysql_sg" {
  name        = "mysql_sg"
  description = "allow registration_app"
  vpc_id      = local.vpc_id

  ingress {
    description     = "allow registration_app"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.registration_app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysql_sg"
  }
}

module "aurora" {
  source = "git::https://github.com/Bkoji1150/aws-rdscluster-kojitechs-tf.git"

  name           = local.name
  engine         = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.10.1"
  instances = {
    1 = {
      instance_class      = "db.r5.large"
      publicly_accessible = false
    }
    2 = {
      identifier     = format("%s-%s", "kojitechs-${var.component_name}", "reader-instance")
      instance_class = "db.r5.2xlarge"
      promotion_tier = 15
    }
  }
  vpc_id                 = local.vpc_id
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  create_db_subnet_group = true
  create_security_group  = false
  subnets                = local.database_subnet

  iam_database_authentication_enabled = true
  create_random_password              = false

  apply_immediately   = false
  skip_final_snapshot = true

  db_parameter_group_name         = aws_db_parameter_group.example.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.example.id
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
}


resource "aws_db_parameter_group" "example" {
  name        = "${local.name}-aurora-db-57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "${local.name}-aurora-db-57-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "example" {
  name        = "${local.name}-aurora-57-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "${local.name}-aurora-57-cluster-parameter-group"
}