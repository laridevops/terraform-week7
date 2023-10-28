# Create a security group
resource "aws_security_group" "my_sg" {
  name        = "webserver.sg"
  description = "Allows SSH and HTTPD"
  vpc_id = aws_vpc.vpc1.id

  # Define inbound rules (ingress rules)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
  }

ingress {
    description = "JENKINS"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow JENKINS from anywhere
  }

egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #means all the available protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    env = "Dev"
  }
}