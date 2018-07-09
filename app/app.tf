# resource "aws_instance" "app" {
#   ami                    = "${var.ami}"
#   instance_type          = "${var.instance_size}"
#   key_name               = "${var.key}"
#   subnet_id              = "${element(var.subnets, 0)}"
#   vpc_security_group_ids = ["${var.sgs}"]
#   user_data              = "${var.user_data}"
#   iam_instance_profile   = "${aws_iam_instance_profile.app_servers.name}"

#   tags {
#     Name = "${var.name} - app_server"
#   }
# }

resource "aws_elb" "elb_app" {
  name            = "${var.name}-elb-App"
  subnets         = ["${var.subnets}"]
  security_groups = ["${var.elb_sg_id}"]
  internal        = true

  cross_zone_load_balancing = true

  listener {
    instance_port     = 8081
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 5
    target              = "TCP:8081"
    interval            = 240
  }

  tags {
    Description = "ELB for ${var.name} app"
    Name        = "${var.name}_elb_app"
  }

  connection_draining         = true
  connection_draining_timeout = 400
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "${var.name}_app_asg"
  min_size                  = "${var.nodes_min}"
  max_size                  = "${var.nodes_max}"
  desired_capacity          = "${var.nodes_desired_capacity}"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.app_launch_config.id}"
  health_check_grace_period = 65
  vpc_zone_identifier       = ["${var.subnets}"]
  load_balancers            = ["${aws_elb.elb_app.name}"]

  //DO NOT REMOVE - need to to create a hard dependancy so that the gateways are created before the asg's
  provisioner "local-exec" {
    command = "echo ${var.nat_gateway_ip} - ${var.param_store_db_url_path}"
  }

  tag {
    key                 = "Name"
    value               = "${var.name} app_server - asg"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "app_launch_config" {
  name_prefix     = "${var.name}_app_launch_cfg"
  image_id        = "${var.ami}"
  instance_type   = "${var.instance_size}"
  security_groups = ["${var.sgs}"]

  lifecycle {
    create_before_destroy = true
  }

  iam_instance_profile = "${aws_iam_instance_profile.app_servers.name}"

  user_data = "${var.user_data}"

  key_name = "${var.key}"
}
