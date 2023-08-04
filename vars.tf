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

# generating password and variables for database

resource "random_password" "password" {
    length          = 16
    special         = true
}

locals {
    db_name         = "Wordpress-DB"
    db_username     = "Maxey"
    db_password     = random_password.password.result
    db_host         = aws_db_instance.mysql-db.address
}
