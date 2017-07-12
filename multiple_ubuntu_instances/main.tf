provider "aws" {
  region     = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

data "aws_ami" "ubuntu-1604" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

variable "environment_names" {default = ["DEV", "QA", "PROD"]}

resource "aws_instance" "okcrb" {
  count         = 3
  ami           = "${data.aws_ami.ubuntu-1604.id}"
  instance_type = "t2.micro"
  tags {
    Name = "${var.environment_names[count.index]}_OKCRB"
  }
}

output "public_ips" "okcrb" {
  value = ["${aws_instance.okcrb.*.public_ip}"]
}
