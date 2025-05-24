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
    from_port   = 30001
    to_port     = 30001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30002
    to_port     = 30002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  ingress {
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["172.31.0.0/16"]
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

resource "aws_instance" "k8s_master" {
  ami           = "ami-0e58b56aa4d64231b" # Amazon Linux or similar
  instance_type = "t3.medium"
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.selenium_sg.id]

  root_block_device {
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name = "k8s-master"
    Role = "k8s-master"
  }
}

resource "aws_instance" "k8s_worker_1" {
  ami           = "ami-0e58b56aa4d64231b" # Amazon Linux or similar
  instance_type = "t3.medium"
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.selenium_sg.id]

  root_block_device {
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name = "k8s-worker-1"
    Role = "k8s-worker"
  }
}

resource "aws_instance" "k8s_worker_2" {
  ami           = "ami-0e58b56aa4d64231b" # Amazon Linux or similar
  instance_type = "t3.medium"
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.selenium_sg.id]

  root_block_device {
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name = "k8s-worker-2"
    Role = "k8s-worker"
  }
}
