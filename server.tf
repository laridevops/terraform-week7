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