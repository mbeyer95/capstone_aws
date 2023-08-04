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

# generating username and password for database
resource "random_password" "password" {
    length          = 16
    special         = true
}

resource "random_pet" "username" {
    length          = 2
}

# variables for database
locals {
    db_name         = "WordpressDB"
    db_username     = random_pet.username.id
    db_password     = random_password.password.result
    db_host         = aws_db_instance.mysql-db.address
}
