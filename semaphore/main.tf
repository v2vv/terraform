
provider "null" {}

locals {
  template_vars = {
    semaphore_password  = var.semaphore_password
  }
}

resource "null_resource" "ru4n" {

  provisioner "remote-exec" {
    inline = [
      <<EOF
        docker rm -f semaphore
        rm -r /root/semaphore/docker-compose.yaml
      EOF
    ]

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }


  provisioner "local-exec" {
    command = <<-EOT
      echo '${templatefile("${path.module}/docker-compose.yaml.tftpl", local.template_vars)}' > generated.yaml
    EOT
  }



  provisioner "remote-exec" {

    inline = [
      "mkdir -p /root/semaphore"
    ]

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }

  provisioner "file" {
    source      = "config.json"
    destination = "/root/semaphore/config.json"

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }

  provisioner "file" {
    source      = "config.json"
    destination = "/root/semaphore/config.json"

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }

  provisioner "file" {
    source      = "generated.yaml"
    destination = "/root/semaphore/docker-compose.yaml"

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }

  provisioner "remote-exec" {
    inline = [
      <<EOF
        docker compose -f /root/semaphore/docker-compose.yml up -d
      EOF
    ]

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
