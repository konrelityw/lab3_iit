provider "aws" {
  region = "eu-north-1"
}


terraform import aws_security_group.web_sg sg-0124f1d16b96ea8a0


resource "aws_instance" "web_instance" {
  ami           = "ami-0c1ac8a41498c1a9c"
  instance_type = "t3.micro"
  key_name      = "keyforlab4"
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "iit-lab6"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu
              sudo docker pull dianay091/lab45:latest
              sudo docker run -d -p 80:80 --name lab45-container dianay091/lab45:latest
              sudo docker run -d --name watchtower --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --interval 30
              EOF
}

output "instance_public_ip" {
  value = aws_instance.web_instance.public_ip
}
