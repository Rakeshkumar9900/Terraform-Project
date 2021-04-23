resource "aws_instance" "terraform" {
    ami = "ami-03ca998611da0fe12"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public-subnet.id
    vpc_security_group_ids =[aws_security_group.prod-sg.id]

    associate_public_ip_address = true
    key_name = "iphone"

    user_data = <<EOF
                    #!/bin/bash
                    sudo yum update -y && sudo yum install -y docker
                    sudo systemctl start docker
                    docker run -p 8080:80 nginx
                EOF

    tags = {
        Name = "terraform"
}
}
