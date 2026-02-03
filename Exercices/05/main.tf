data "aws_ami" "linux" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-ebs"]
  }

  owners = ["137112412989"]
}

resource "aws_instance" "apache" {
  instance_type = "t2.micro"
  ami = data.aws_ami.linux.id

  user_data = <<-EOF
#cloud-init

packages:
  - httpd

runcmd:
  - systemctl enable httpd
  - systemctl start httpd
EOF
}

resource "aws_instance" "nginx" {
  instance_type = "t2.micro"
  ami = data.aws_ami.linux.id

  connection {
    type = "ssh"
    user = "ec2-user"
    # !!! La clé ne doit pas être verrouillée par passphrase
    # private_key = file("~/.ssh/id_rsa")
    # Si la clé est verouillée avec une passphrase
    # dans ce cas il faut utiliser l'agent
    # avant de lancer la commande terraform apply
    # il faudra executer
    # ssh-add ~/.ssh/id_rsa
    agent = true
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
    ]
  }
}

data "archive_file" "projet" {
  type = "tar.gz"
  source_dir = "./deploy/projet_exemple"
  output_path = "./deploy/projet_exemple.tar.gz"
}

resource "aws_instance" "projet" {
  instance_type = "t2.micro"
  ami = data.aws_ami.linux.id

  depends_on = [
    data.archive_file.projet
  ]

  provisioner "file" {
    connection {
      type = "ssh"
      user = "ec2-user"
      # !!! La clé ne doit pas être verrouillée par passphrase
      # private_key = file("~/.ssh/id_rsa")
      # Si la clé est verouillée avec une passphrase
      # dans ce cas il faut utiliser l'agent
      # avant de lancer la commande terraform apply
      # il faudra executer
      # ssh-add ~/.ssh/id_rsa
      agent = true
      host = self.public_ip
    }

    source = "deploy/projet_exemple.tar.gz"
    destination = "/opt/projet.tar.gz"
  }

  user_data = templatefile("./deploy/cloud-init-projet.yml", {})
}

resource "aws_instance" "compose" {
  instance_type = "t2.micro"
  ami = data.aws_ami.linux.id

  depends_on = [
    data.archive_file.projet
  ]

  user_data = templatefile("./deploy/cloud-init-compose.yml", {
    compose = base64encode(file("./deploy/docker-compose.yml"))
  })
}