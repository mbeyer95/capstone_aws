resource "aws_launch_template" "launchtemplate" {
    name                        = "wordpress-launchtemplate"
    image_id                    = data.aws_ami.latest_linux_ami.id
    instance_type               = var.instance_type
    vpc_security_group_ids      = [aws_security_group.autoscaling-sg.id]
    user_data                   = base64encode(file("userdata.sh"))
}

resource "aws_autoscaling_group" "autoscalinggroup" {
    name                        = "wordpress-autoscalinggroup"
    max_size                    = 4
    min_size                    = 2
    desired_capacity            = 2
    vpc_zone_identifier         = local.public_subnets
    target_group_arns           = [aws_lb_target_group.targetgroup.arn]
    health_check_type           = "ELB"
    health_check_grace_period   = 300
    
    launch_template {
        id                      = aws_launch_template.launchtemplate.id
        version                 = "$Latest"
    }
}