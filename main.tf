#---------------------------
#Build my webserver
#---------------------------


provider "aws" {
    region = "us-east-1"
}



resource "aws_instance" "myWebServer" {
    ami = "ami-005f9685cb30f234b"
	instance_type = "t2.micro"
	tags = {
		Name = "WEb-server"
		Owner = "Terraform"
		Project = "WS"
	}
    vpc_security_group_ids = [aws_security_group.WSSG.id]
    user_data = <<EOF
#!/bin/bash
yum update -y
yum install httpd -y
myip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo "<h2>WEB SERVER with ip: $myip</h2><br> Built WITH TERRAFORM" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF

}


resource "aws_security_group" "WSSG" {
  name        = "web-server"
  description = "My first security group"

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  	tags = {
		Name = "WEb-server-sg"
		Owner = "Terraform"
		Project = "WS-sg"
	}
}
