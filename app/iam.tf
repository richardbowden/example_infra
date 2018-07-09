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

resource "aws_iam_policy" "app_server_readonly_policy" {
  name = "${var.name}_app_server_readonly"
  path = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:ListAllMyBuckets"
            ],
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Effect": "Deny",
            "Action": [
                "s3:ListBucket"
            ],
            "NotResource": [
                "arn:aws:s3:::rbexamplebuiltbin",
                "arn:aws:s3:::rbexamplebuiltbin/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::rbexamplebuiltbin",
                "arn:aws:s3:::rbexamplebuiltbin/*"
            ],
            "Condition": {}
        }
    ]
}
EOF
}

data "aws_kms_key" "ssm" {
  key_id = "alias/aws/ssm"
}

resource "aws_iam_policy" "app_server_ssm_access_readonly" {
  name = "${var.name}_app_server_ssm_access_readonly"
  path = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
         {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeParameters"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParametersByPath",
                "ssm:GetParameters",
                "ssm:GetParameter"
            ],
            "Resource": "arn:aws:ssm:eu-west-1:233596137442:parameter/database*"
        },

        {
            "Effect": "Allow",
            "Action": [
                "kms:Describe*",
                "kms:Get*",
                "kms:List*",
                "kms:Decrypt"
            ],
            "Resource": "arn:aws:kms:eu-west-1:233596137442:key/b8fc8fe9-1e73-42b6-9414-35ec77e20bf4"
        }
    ]
}
EOF
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
