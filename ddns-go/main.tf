
provider "null" {}
locals {
  template_vars = {
    ddns-go_password = var.ddns-go_password
    cloudflare_token = var.cloudflare_token
  }
}

resource "null_resource" "ddns_go" {

#停止容器
  provisioner "local-exec" {
    inline = [
      "docker compose -f /root/ddns-go/docker-compose.yaml down"
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
      mkdir -p temp
      echo '${templatefile("${path.module}/templates/.ddns_go_config.yaml.tftpl", local.template_vars)}' > temp/generated.yaml
    EOT
  }

    provisioner "local-exec" {
    command = <<-EOT
      cat temp/generated.yaml
    EOT
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /root/ddns-go"
    ]

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }


  provisioner "file" {
    source      = "temp/generated.yaml"
    destination = "/root/ddns-go/.ddns_go_config.yaml"

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }

  provisioner "file" {
    source      = "files/docker-compose.yaml"
    destination = "/root/ddns-go/docker-compose.yaml"

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
      docker compose -f /root/ddns-go/docker-compose.yaml up -d
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
