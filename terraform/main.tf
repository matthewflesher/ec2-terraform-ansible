provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "selenium-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "selenium_sg" {
  name        = "selenium-sg"
  description = "Allow SSH and Selenium"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4444
    to_port     = 4444
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "selenium_hub" {
  ami           = "ami-0c02fb55956c7d316"  # Ubuntu 20.04 (us-east-1)
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.selenium_sg.name]

  tags = {
    Name = "SeleniumHub"
  }

  provisioner "remote-exec" {
    inline = ["echo instance ready"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}

output "public_ip" {
  value = aws_instance.selenium_hub.public_ip
}