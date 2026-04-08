data "aws_ami" "debian_ami" {
  most_recent = true
  owners      = ["136693071363"]

  filter {
    name   = "name"
    values = ["debian-13-amd64-*"]
  }
}

data "aws_ami" "kali_ami" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["debian-kali-*"]
  }

  filter {
    name   = "image-id"
    values = ["ami-003fa928ba1faa587"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "aws_ami" "redhat_ami" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["RHEL-10.0.0_HVM-*"]
  }
}
