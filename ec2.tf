# Select newest AMI-id

data "aws_ami" "latest_linux_ami" {
    most_recent             = true
    owners                  = ["amazon"]
    
    filter {
        name                = "name"
        values              = ["amzn2-ami-hvm-*-x86_64-gp2"]
        }
    filter {
        name                = "virtualization type"
        values              = ["hvm"]
        }
}

# Create EC2
resource "aws_instance" "bastion-host"{
    ami                     = data.aws_ami.latest_linux_ami.id
    instance_type           = var.instance_type
    key_name                = "vockey"
    vpc_security_group_ids  = [aws_security_group.bastion-sg.id]
    subnet_id               = aws_subnet.publicsubnet1.id
    tags = {
        Name = "Bastion"
        }
    user_data = file("userdata.sh")

# Create Metadata
    provisioner "local-exec"{
        command = "echo -e 'Instance Type = ${self.instance_type}\nInstance ID = ${self.id}\nPublic DNS = ${self.public_dns}\nAMI ID = ${self.ami}\n' >> allinstancedetails"
    }
}