
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's owner ID for Ubuntu images
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/*24.04-amd64*"]
  }
}

resource "aws_key_pair" "terra-key" {
  key_name   = "${var.env}-terra-key"
  public_key = file("terra-key.pub")

  tags = {
    Name = "${var.env}-terra-key"
  }
}

resource "aws_default_vpc" "default" {


}

resource "aws_default_security_group" "mygroup" {
  vpc_id = aws_default_vpc.default.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH traffic"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic"
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Jenkins"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "automate-sg"
  }

}

resource "aws_instance" "my_instance" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.terra-key.key_name
  security_groups = [aws_default_security_group.mygroup.name]
  user_data       = file("${path.module}/install_tools.sh")

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
  }

  tags = {
    Name = "${var.env}-instance"
  }

}