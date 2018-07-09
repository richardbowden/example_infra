data "template_file" "userdata" {
  template = "${var.user_data}" # "${file("${path.module}/init.tpl")}"

  vars {
    app_elb = "${var.app_elb_dns_name}"
  }
}

# resource "aws_instance" "web" {
#   ami                    = "${var.ami}"
#   instance_type          = "${var.instance_size}"
#   key_name               = "${var.key}"
#   subnet_id              = "${element(var.subnets, 0)}"
#   vpc_security_group_ids = ["${var.sgs}"]
#   user_data              = "${data.template_file.userdata.rendered}"

#   tags {
#     Name = "${var.name} - web_server"
#   }
# }

resource "aws_elb" "elb_web" {
  name            = "${var.name}-elb-web"
  subnets         = ["${var.subnets}"]
  security_groups = ["${var.elb_sg_id}"]

  cross_zone_load_balancing = true

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 5
    target              = "TCP:80"
    interval            = 10
  }

  tags {
    Description = "ELB for ${var.name} web"
    Name        = "${var.name}_elb_app"
  }

  connection_draining         = true
  connection_draining_timeout = 400
}

resource "aws_autoscaling_group" "web_asg" {
  name                      = "${var.name}_web"
  min_size                  = "${var.nodes_min}"
  max_size                  = "${var.nodes_max}"
  desired_capacity          = "${var.nodes_desired_capacity}"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.web_launch_config.id}"
  health_check_grace_period = 65
  vpc_zone_identifier       = ["${var.subnets}"]
  load_balancers            = ["${aws_elb.elb_web.name}"]

  tag {
    key                 = "Name"
    value               = "${var.name} web_server - asg"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "web_launch_config" {
  name_prefix     = "${var.name}_web_launch_cfg"
  image_id        = "${var.ami}"
  instance_type   = "${var.instance_size}"
  security_groups = ["${var.sgs}"]

  lifecycle {
    create_before_destroy = true
  }

  # iam_instance_profile = "${aws_iam_instance_profile.web_servers.name}"

  user_data = "${data.template_file.userdata.rendered}"
  key_name  = "${var.key}"
}
