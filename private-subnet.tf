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