# Select newest AMI-id

data "aws_ami" "latest_linux_ami" {
    most_recent             = true
    owners                  = ["amazon"]
    
    filter {
        name                = "name"
        values              = ["amzn2-ami-hvm-*-x86_64-gp2"]
        }
}

# Create EC2
resource "aws_instance" "bastion-host"{
    ami                     = "ami-08541bb85074a743a"
    instance_type           = var.instance_type
    key_name                = "vockey"
    vpc_security_group_ids  = [aws_security_group.bastion-sg.id]
    subnet_id               = aws_subnet.publicsubnet1.id
    tags = {
        Name = "Bastion"
        }
    user_data = file("userdata.sh")

# create metadata
    provisioner "local-exec"{
        command = "echo Instance Type=${self.instance_type},Instance ID=${self.id},Public DNS=${self.public_dns},AMI ID=${self.ami} >> allinstancedetails"
    }
}