provider "aws" {
  region  = var.region
  profile = "default"
}

resource "aws_instance" "test_server" {
  count         = var.node_count
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.pem_file_name

  associate_public_ip_address = true
  vpc_security_group_ids      = var.security_group
  subnet_id                   = var.subnet_id
  availability_zone           = var.az
  tags = {
    "Name"     = "${var.user}_CRDB_${count.index + 1}"
    "yb_dept"  = "perf"
    "yb_task"  = "tpcc"
    "yb_owner" = var.user
  }

  connection {
    type        = "ssh"
    user        = "centos"
    private_key = file(var.pem_file_path)
    host        = self.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo Hello World!"
    ]
  }
}

output "server_private_ip" {
  value = aws_instance.test_server.*.private_ip
}

#When using the tar
resource "local_file" "AnsibleInventory1" {
  content = templatefile("inventory.tmpl",
    {
      client_ips = aws_instance.test_server.*.private_ip
      az         = var.az
      region     = var.region
    }
  )
  filename = "inventory"
}
