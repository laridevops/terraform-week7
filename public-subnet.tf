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