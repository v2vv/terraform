
provider "null" {}
locals {
  template_vars = {
    ddns-go_password  = var.ddns-go_password
  }
}

resource "null_resource" "ru4n" {

  provisioner "local-exec" {
    command = <<-EOT
      echo '${templatefile("${path.module}/.ddns_go_config.yaml.tftpl", local.template_vars)}' > generated.yaml
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
    source      = ".ddns_go_config.yaml"
    destination = "/root/ddns-go/.ddns_go_config.yaml"

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
      docker run -d --name ddns-go --restart=always --net=host -v /root/ddns-go/:/root jeessy/ddns-go
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
