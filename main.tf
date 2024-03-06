
resource "aws_iam_group" "developers" {
  name = "developers"
}
  
  
resource "aws_iam_user" "lb" {
  name = "simon2050"
 }



resource "aws_instance" "server1" {

  ami           = "ami-026b57f3c383c2eec"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.sg-demo.name] 
  key_name      = "week7d2"
  tags = {
    Name = "Terraform server"
    Team = "DevOps"
    env  = "dev"
  }
  user_data = file("install.sh")
}


# create default vpc if one does not exit
resource "aws_default_vpc" "default_vpc" {
}

  # Create Web Security Group
resource "aws_security_group" "web-sg" {
  name        = "docker-Web-SG"
  description = "Allow ssh and http inbound traffic"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
      description = "ingress port "
      #from_port   = ingress.value
      from_port   = 8000
      to_port     = 8100
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    
  }
  ingress {
      description = "ingress port "
      #from_port   = ingress.value
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "docker-Web-SG"
  }
}

  
# Generates a secure private k ey and encodes it as PEM
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
# Create the Key Pair
resource "aws_key_pair" "ec2_key" {
  key_name   = "privatekeypair"  
  public_key = tls_private_key.ec2_key.public_key_openssh
}
# Save file
resource "local_file" "ssh_key" {
  filename = "keypair.pem"
  content  = tls_private_key.ec2_key.private_key_pem
}

#data for amazon linux

data "aws_ami" "amazon-2" {
    most_recent = true
  
    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-ebs"]
    }
    owners = ["amazon"]
  }
 
#create ec2 instances 

resource "aws_instance" "DockerInstance" {
  ami                    = data.aws_ami.amazon-2.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = aws_key_pair.ec2_key.key_name
  user_data              = file("install.sh")
 
  tags = {
    Name = "docker instance"
  }
 
}

