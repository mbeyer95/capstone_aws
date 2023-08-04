resource "aws_lb" "alb" {
    name                        = "Wordpress-alb"
    internal                    = false
    load_balancer_type          = "application"
    security_groups             = [aws_security_group.alb-sg.id]
    subnets                     = [aws_subnet.publicsubnet1.id, aws_subnet.publicsubnet2.id]
    enable_deletion_protection  = false
        tags = {
            Environment         = "production"
        }
}

resource "aws_lb_target_group" "targetgroup" {
    name = "Wordpress-targetgroup"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc.id
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.alb.arn
    port = "80"
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.targetgroup.arn
    }
}