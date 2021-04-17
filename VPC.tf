resource "aws_vpc" "prod-vpc" {
    cidr_block = "100.0.0.0/16"
    instance_tenancy = "default"
    
    tags = {
        Name = "prod-vpc"

    }
  
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.prod-vpc.id

    tags = {
        Name = "myigw"
    }
}

resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "100.0.1.0/24"
    availability_zone = "ap-southeast-1a"

    tags = {
        Name = "public-subnet"
    }
}

