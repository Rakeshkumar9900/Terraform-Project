resource "aws_vpc" "prod" {
    cidr_block = "100.0.0.0/16"
    instance_tenancy = "default"
    
    tags = {
        Name = "prod"

    }
  
}

resource "aws_internet_gateway" "prod-gw" {
    vpc_id = aws_vpc.prod.id

    tags = {
        Name = "myigw"
    }
}

resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.prod.id
    cidr_block = "100.0.1.0/24"
    availability_zone = "ap-southeast-1a"

    tags = {
        Name = "public-subnet"
    }
}

resource "aws_route_table" "Pub-Prod" {
  vpc_id = aws_vpc.prod.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod-gw.id
  }

  tags = {
    Name = "Pub-Prod"
  }
}

resource "aws_route_table_association" "public-subnet" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.Pub-Prod.id
}

resource "aws_security_group" "prod-sg"{
    name = "prod-sg"
    vpc_id = aws_vpc.prod.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        
}

    tags = {
        Name = "allow_tls"
  }
}
