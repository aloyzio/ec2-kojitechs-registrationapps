
resource "aws_iam_role" "ssm_fleeet_ec2" {
  name = "ssm_fleeet_ec2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "ssm_fleeet_ec2"
  }
}

resource " aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile"
  role = aws_iam_role.ssm_fleet_ec2.name
}

resource "aws_iam_policy" "policy" {
  name        = format("%s-%s", var.component_name, "ssm_policy")
  description = "Access  policy of ec2 to ssm fleet"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
          "ec2:*",
          "ec2messages:*",
          "ecr:*",
          "ecs:*",
          "elasticfilesystem:*",
          "elasticache:*",
          "elasticloadbalancing:*",
          "es:*",
          "events:*",
          "iam:*",
          "kms:*",
          "lambda:*",
          "logs:*",
          "rds:*",
          "route53:*",
          "ssm:*",
          "ssmmessages:*",
          "s3:*",
          "sns:*",
          "sqs:*",
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeInstances",
          "ec2:AttachNetworkInterface"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource " aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  name = "instance_profile"
  role = aws_iam_role.ssm_fleet_ec2.name
}