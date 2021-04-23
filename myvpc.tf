resource "aws_vpc" "production" {
    cidr_block = "200.0.0.0/16"
    instance_tenancy = "default"
    
    tags = {
        Name = "production"

    }
  
}

resource "aws_internet_gateway" "production-gw" {
    vpc_id = aws_vpc.production.id

    tags = {
        Name = "production"
    }
}

resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.production.id
    cidr_block = "200.0.1.0/24"
    availability_zone = "ap-southeast-1a"

    tags = {
        Name = "public-subnet"
    }
}

resource "aws_subnet" "private-subnet" {
    vpc_id = aws_vpc.production.id
    cidr_block = "200.0.2.0/24"
    availability_zone = "ap-southeast-1b"

    tags = {
        Name = "private-subnet"
    }
}



resource "aws_route_table" "Public-Production" {
  vpc_id = aws_vpc.production.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.production-gw.id
  }

  tags = {
    Name = "Public-Production"
  }
}

resource "aws_route_table" "Private-Production" {
  vpc_id = aws_vpc.production.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.production-gw.id
  }

  tags = {
    Name = "Private-Production"
  }
}


resource "aws_route_table_association" "public-subnet" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.Public-Production.id
}

resource "aws_route_table_association" "private-subnet" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.Private-Production.id
}

resource "aws_security_group" "production-sg"{
    name = "production-sg"
    vpc_id = aws_vpc.production.id

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
