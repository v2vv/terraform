
provider "null" {}

resource "null_resource" "semaphore" {

#停止容器
  provisioner "remote-exec" {

    inline = [
      "docker rm -f semaphore"
    ]

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }


#创建配置文件夹
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


#上传配置文件
  provisioner "file" {
    source      = "files/config.json"
    destination = "/root/semaphore/config.json"

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }

#上传配置文件
  provisioner "file" {
    source      = "files/config.json"
    destination = "/root/semaphore/config.json"

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }

#上传配置文件
  provisioner "file" {
    source      = "files/docker-compose.yaml"
    destination = "/root/semaphore/docker-compose.yaml"

    connection {
      type        = "ssh"
      user        = "root"  # 修改为你目标主机的用户名
      password    = "${var.root_password}"
      host        = "${var.host}" # 修改为你的目标主机 IP 或域名
    }
  }

#执行安装命令
  provisioner "remote-exec" {
    inline = [
      <<EOF
        docker compose -f /root/semaphore/docker-compose.yaml up -d
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
