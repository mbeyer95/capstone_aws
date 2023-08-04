variable "cidr_block" {
    default = "0.0.0.0/0"
}

variable region {
    default = "us-west-2"
}

variable "instance_type" {
    default = "t2.micro"  
}

variable "vpc_zone_public" {
    default = "aws_subnet.publicsubnet1.id, aws_subnet.publicsubnet2.id"
}