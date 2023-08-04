resource "aws_launch_template" "launchtemplate" {
    name                        = "wordpress-launchtemplate"
    image_id                    = data.aws_ami.latest_linux_ami
    instance_type               = var.instance_type
    vpc_security_group_ids      = [aws_security_group.autoscaling-sg.id]
    user_data                   = file("userdata.sh")
}

resource ""aws_autoscaling_group"" "autoscalinggroup" {
    name                        = "autoscaling-group"
    max_size                    = 4
    min_size                    = 2
    desired_capacity            = 2
    vpc_zone_identifier         = var.vpc_zone_public
    target_group_arns           = [aws_lb_target_group.targetgroup.arn]
    health_check_type           = "ELB"
    health_check_grace_period   = 300
    launch_template {
        id                      = aws_launch_template.launchtemplate.id
        version                 = "$Latest"
    }
}

/**
resource "aws_autoscaling_policy" "autoscalingpolicy" {
    name                        = "Policy"
    policy_type                 = "TargetTrackingScaling"



}

**/