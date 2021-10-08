resource "aws_security_group" "myfirstsg" {
  name        = "server_access"
  description = "Allow TLS inbound traffic"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "myfirstinstance" {
  ami                  = "ami-02e136e904f3da870"
  instance_type        = "t2.micro"
  security_groups      = ["${aws_security_group.myfirstsg.name}"]
  iam_instance_profile = aws_iam_instance_profile.demo-role.id

  tags = {
    Name = "testinstance"
  }
}

resource "aws_ebs_volume" "Forpractice" {
  availability_zone = "us-east-1a"
  size              = 5

  tags = {
    Name = "ForDevopsPractice"
  }
}

resource "aws_iam_policy_attachment" "global-policy-attachemnt" {
  name       = "remote-access-attachment"
  roles      = [aws_iam_role.demo-role.id]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "demo-role" {
  name = "testprofile"
  role = aws_iam_role.demo-role.id
}

resource "aws_iam_role" "demo-role" {
  name = "demo-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "roleforterraform"
  }
}