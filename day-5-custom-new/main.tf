#create vpc
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
       Name ="cust-vpc"
    }
  
}
#create one public subnet
resource "aws_subnet" "public_subnet" {# this is my code 
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "public_subnet"
    }
  
}
 #create one private subnet
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.2.0/24"
    tags = {
        Name = "private_subnet"
    }
  
}

#create ig attach to vpc

resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name = "cust-ig"
    }

}
#create rt and edit routes

    resource "aws_route_table" "public" {
  vpc_id = aws_vpc.name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  }

  tags = {
    Name = "public-route-table"
  }
}


    #create subnet association
    resource "aws_route_table_association" "subnet-1" {
        subnet_id = aws_subnet.public_subnet.id
        route_table_id = aws_route_table.public.id
      
    }

    resource "aws_route_table_association" "subnet-2" {
        subnet_id = aws_subnet.private_subnet.id
        route_table_id = aws_route_table.private.id
        
        }
      
    


#create sg

resource "aws_security_group" "name" {
    vpc_id = aws_vpc.name.id
  
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cust-sg"
  }
}

#elastic ip
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "cust-nat"
  }
}
#create nat
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on    = [aws_internet_gateway.name]
}
# nat rt
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "cust-rt-nat"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

#private rout table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}

# create one public ec2
resource "aws_instance" "public_subnet" {
    ami = "ami-07860a2d7eb515d9a"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id
    vpc_security_group_ids = [ aws_security_group.name.id ]
    associate_public_ip_address = true
    tags = {
      Name = "public-ec2"
    }
  
}

#create one private ec2
resource "aws_instance" "private_subnet" {
  ami = "ami-07860a2d7eb515d9a"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private_subnet.id
  vpc_security_group_ids = [ aws_security_group.name.id ]
  tags = {
    Name = "private-ec2"
  }
  
}





