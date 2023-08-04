# Query all available Availability Zone; we will use specific availability zone using index - The Availability Zones data source
# provides access to the list of AWS availabililty zones which can be accessed by an AWS account specific to region configured in the provider.
data "aws_availability_zones" "vpc_azs"{}

#Create a Virtual private cloud with CIDR 10.0.0.0/16 in the region us-west-2
resource "aws_vpc" "vpc"{
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "vpc"
    }
    provisioner "local-exec"{
    command = "echo VPC = ${self.id} >> metadata"
  }
}

# Public Subnet 1
resource "aws_subnet" "publicsubnet1"{
    cidr_block = "10.0.1.0/24" # 256 IPs
    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.vpc_azs.names[1]

    tags = {
        Name = "publicsubnet1"
    }
    provisioner "local-exec"{
    command = "echo PublicSubnet1 = ${self.id} >> metadata"
  }
}

# Private Subnet 1
resource "aws_subnet" "privatesubnet1"{
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.vpc_azs.names[1]
    
    tags = {
            Name = "privatesubnet1"
    }
    provisioner "local-exec"{
    command = "echo PrivateSubnet1 = ${self.id} >> metadata"
  }
}

# Public Subnet 2
resource "aws_subnet" "publicsubnet2"{
    cidr_block = "10.0.3.0/24" # 256 IPs
    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.vpc_azs.names[2]

    tags = {
        Name = "publicsubnet2"
    }
    provisioner "local-exec"{
    command = "echo PublicSubnet2 = ${self.id} >> metadata"
  }
}

# Private Subnet 2
resource "aws_subnet" "privatesubnet2"{
    cidr_block = "10.0.4.0/24"
    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.vpc_azs.names[2]
    
    tags = {
            Name = "privatesubnet2"
    }
    provisioner "local-exec"{
    command = "echo PrivateSubnet2 = ${self.id} >> metadata"
  }
}

# Internet Gateway - to have Internet traffic in public subnets
resource "aws_internet_gateway" "IGW"{
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "vpc_igw"
    }
    provisioner "local-exec"{
    command = "echo InternetGateway = ${self.id} >> metadata"
  }
}

# Routing tables

# Provides a resource to create a VPC routing table
resource "aws_route_table" "publicRouteTable1"{
    vpc_id = aws_vpc.vpc.id
    route{
        cidr_block = var.cidr_block
        gateway_id = aws_internet_gateway.IGW.id
    }
    tags = {
        Name = "publicRoute1"
    }
}

# Provides a resource to create an association between a Public Route Table and a Public Subnet
resource "aws_route_table_association" "publicSubnetAssociation1" {
    route_table_id = aws_route_table.publicRouteTable1.id
    subnet_id = aws_subnet.publicsubnet1.id
    depends_on = [aws_route_table.publicRouteTable1, aws_subnet.publicsubnet1]
}

# Provides a resource to create an association between a Public Route Table and a Public Subnet
resource "aws_route_table_association" "publicSubnetAssociation2" {
    route_table_id = aws_route_table.publicRouteTable1.id
    subnet_id = aws_subnet.publicsubnet2.id
    depends_on = [aws_route_table.publicRouteTable1, aws_subnet.publicsubnet2]
}

# Adding NAT Gatway
# Create Elastic IP. The advantage of associating the Elastic IP address with the network interface instead of directly with the instance is that you can move all the attributes of the network interface from one instance to another in a single step.

#resource "aws_eip" "ip" {
#    domain = "vpc"
##   vpc = true
#    tags = {
#    Name = "elastic_ip"
#  }
#}

# NAT Gateway in public subnet and assigned the above created Elastic IP to it .

#resource "aws_nat_gateway" "NatGateway" {
#  allocation_id = "${aws_eip.ip.id}"
#  subnet_id     = "${aws_subnet.publicsubnet1.id}"
#
#
#  tags = {
#    Name = "NatGateway"
#  }
#}

#Create a Route Table in order to connect our private subnet to the NAT Gateway .

resource "aws_route_table" "privateRouteTable1" {
  vpc_id = "${aws_vpc.vpc.id}"


#  route {
#    cidr_block = var.cidr_block
#    gateway_id = "${aws_nat_gateway.NatGateway.id}"
#  }

  tags = {
    Name = "privateRoute1"
  }
}

# Associate this route table to private subnet 

 resource "aws_route_table_association" "private_association1" {
    route_table_id = aws_route_table.privateRouteTable1.id
    subnet_id = aws_subnet.privatesubnet1.id
    depends_on = [aws_route_table.privateRouteTable1, aws_subnet.privatesubnet1]
}

resource "aws_route_table_association" "private_association2" {
    route_table_id = aws_route_table.privateRouteTable1.id
    subnet_id = aws_subnet.privatesubnet2.id
    depends_on = [aws_route_table.privateRouteTable1, aws_subnet.privatesubnet2]
}