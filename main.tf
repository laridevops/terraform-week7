resource "aws_vpc" "vpc1" {
cidr_block =  "172.120.0.0/16" 
instance_tenancy = "default"

tags= {
        Name = "Terraform-vpc"
        env = "Dev"
    } 
}

# Create two public subnets within the VPC
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "172.120.1.0/24"  # Replace with your desired subnet IP range
  availability_zone = "us-east-1a"  # Replace with your desired availability zone
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public-subnet2" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "172.120.2.0/24"  # Replace with your desired subnet IP range
  availability_zone = "us-east-1b"  # Replace with your desired availability zone
  map_public_ip_on_launch = true
}

# Create two private subnets within the VPC
resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "172.120.3.0/24"  # Replace with your desired subnet IP range
  availability_zone = "us-east-1a"  # Replace with your desired availability zone
}

resource "aws_subnet" "private-subnet2" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "172.120.4.0/24"  # Replace with your desired subnet IP range
  availability_zone = "us-east-1b"  # Replace with your desired availability zone
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc1.id  # Replace with the ID of your VPC
}

# Create a route table
resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc1.id  # Replace with the ID of your VPC
}

# Create a route in the route table (e.g., default route to the Internet Gateway)
resource "aws_route" "route_to_igw" {
  route_table_id         = aws_route_table.rt1.id
  destination_cidr_block = "0.0.0.0/0"  # Replace with the desired destination (e.g., 0.0.0.0/0 for the Internet)
  gateway_id             = aws_internet_gateway.my_igw.id  # Replace with the ID of your Internet Gateway
}

# Route association
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.rt1.id
}

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

# Define an EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-01eccbf80522b562b"  # Replace with your desired AMI ID
  instance_type = "t2.micro"      # Replace with your desired instance type
  key_name      = "utc-key"   # Replace with your key pair name
  subnet_id     = aws_subnet.public-subnet.id  # Replace with your subnet ID
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  count        = 1  # Number of instances to create
  user_data = file("install.sh")

  tags = {
        Name = "utc-dev-inst"
        Team = "Cloud Transformation"
        Environment = "Dev"
        Createdby = "Larrie"
      }
}

output "public-ip" {
    value = aws_instance.my_instance[0].public_ip
}