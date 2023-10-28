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