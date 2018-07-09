resource "aws_iam_role" "app_servers" {
  name = "${var.name}-app_servers"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "app_servers" {
  name = "${var.name}-app_servers"
  role = "${aws_iam_role.app_servers.name}"
}

data "aws_iam_policy_document" "s3_deploy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    effect = "Deny"

    actions = [
      "s3:ListBucket",
    ]

    not_resources = [
      "arn:aws:s3:::${var.deploy_bucket}",
      "arn:aws:s3:::${var.deploy_bucket}/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.deploy_bucket}",
      "arn:aws:s3:::${var.deploy_bucket}/*",
    ]
  }
}

resource "aws_iam_policy" "app_server_readonly_policy" {
  name = "${var.name}_app_server_readonly"
  path = "/"

  policy = "${data.aws_iam_policy_document.s3_deploy.json}"
}

data "aws_kms_key" "ssm" {
  key_id = "${var.app_ssm_kms_key}"
}

data "aws_iam_policy_document" "ssm_access_readonly" {
  statement {
    effect = "Allow"

    actions = [
      "ssm:DescribeParameters",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter",
    ]

    resources = [
      "arn:aws:ssm:${var.region}:${data.aws_kms_key.ssm.aws_account_id}:parameter/database*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:Describe*",
      "kms:Get*",
      "kms:List*",
      "kms:Decrypt",
    ]

    resources = [
      "${data.aws_kms_key.ssm.arn}",
    ]
  }
}

resource "aws_iam_policy" "app_server_ssm_access_readonly" {
  name = "${var.name}_app_server_ssm_access_readonly"
  path = "/"

  policy = "${data.aws_iam_policy_document.ssm_access_readonly.json}"
}

# IAM Policy Attachments
resource "aws_iam_policy_attachment" "app_server_readonly_policy" {
  name       = "${var.name}_app_server_readonly"
  roles      = ["${aws_iam_role.app_servers.name}"]
  policy_arn = "${aws_iam_policy.app_server_readonly_policy.arn}"
}

resource "aws_iam_policy_attachment" "app_server_ssm_readonly_policy" {
  name       = "${var.name}_app_server_readonly"
  roles      = ["${aws_iam_role.app_servers.name}"]
  policy_arn = "${aws_iam_policy.app_server_ssm_access_readonly.arn}"
}
