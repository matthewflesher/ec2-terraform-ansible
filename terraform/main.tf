provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "selenium-key"
  public_key = var.ssh_public_key
}

resource "aws_security_group" "selenium_sg" {
  name        = "selenium-sg"
  description = "Allow SSH and Selenium"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP access to Selenium Hub"
    from_port   = 4444
    to_port     = 4444
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "selenium-sg"
  }
}

resource "aws_instance" "selenium_hub" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux or similar
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.selenium_sg.id]

  tags = {
    Name = "SeleniumHub"
  }
}

output "public_ip" {
  value = aws_instance.selenium_hub.public_ip
}