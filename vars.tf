variable "cidr_block" {
    default         = "0.0.0.0/0"
}

variable region {
    default         = "us-west-2"
}

variable "instance_type" {
    default         = "t2.micro"  
}

locals {
    public_subnets  = [aws_subnet.publicsubnet1.id, aws_subnet.publicsubnet2.id]
}

locals {
    db_name         = "Wordpress-DB"
    db_username     = "Maxey"
    db_password     = "password1234"
}
