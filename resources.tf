resource "aws_key_pair" "terraform_key" {
  key_name   = var.key_pair_name
  public_key = file("${path.module}/terraform_key_rsa.pub")
}


resource "aws_security_group" "terraform_sg" {
  name        = "${var.instance_name}-sg"
  description = "Allow TLS inbound and outbound traffic"

  dynamic "ingress" {
    for_each = var.inbound_ports
    iterator = port
    content {
      description      = "TLS from VPC"
      from_port        = port.value
      to_port          = port.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_instance" "terraform-ec2" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }
  root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
  }
  key_name               = aws_key_pair.terraform_key.key_name
  vpc_security_group_ids = ["${aws_security_group.terraform_sg.id}"]

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("${path.module}/terraform_key_rsa")	
    host = self.public_ip
  }

  provisioner "remote-exec" {
    script = "./script.sh"
  }

}

