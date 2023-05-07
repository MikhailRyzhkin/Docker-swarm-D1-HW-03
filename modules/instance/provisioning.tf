# Подключемся через Terraform к manage ноде с использованием ключа.
resource "null_resource" "docker-swarm-manager" {
  count = var.managers
  depends_on = [yandex_compute_instance.vm-manager]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.vm-manager[count.index].network_interface.0.nat_ip_address
  }

# Копируем в manage ноду docker-compose файл по относительному пути от папки проекта для разворачивания стэка на будущих нодах
# https://developer.hashicorp.com/terraform/language/resources/provisioners/file
  provisioner "file" {
    source      = "docker-compose/docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yml"
  }

# Устанавливаем на manage ноду git, docker-compose, активируем режим docker swarm, поднимаем вэб-панель portainer для визуального управления кластером и сервисами стэка.
# https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get install -y git curl ca-certificates curl gnupg lsb-release gnome-terminal apt-transport-https gnupg-agent software-properties-common",
      "curl -fsSL https://get.docker.com | sh",
      "sudo usermod -aG docker $USER",
      "sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y",
      "sudo systemctl enable docker.service && sudo systemctl enable containerd.service && sudo systemctl start docker.service && sudo systemctl start containerd.service",
      "sudo docker swarm init",      
      "sleep 25",
      "echo COMPLETED"
    ]
  }
}

# Перепододключемся через Terraform к manage ноде с использованием ключа для создания скрипта с токеном присоединения к кластеру остальных нод.
resource "null_resource" "docker-swarm-manager-join" {
  count = var.managers
  depends_on = [yandex_compute_instance.vm-manager, null_resource.docker-swarm-manager]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.vm-manager[count.index].network_interface.0.nat_ip_address
  }

# Создаём скрипт с командой добавления worker ноды к кластеру docker swarm и сохраняем локально в рабочем каталоге
# https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec
  provisioner "local-exec" {
    command = "TOKEN=$(ssh -i ${var.ssh_credentials.private_key} -o StrictHostKeyChecking=no ${var.ssh_credentials.user}@${yandex_compute_instance.vm-manager[count.index].network_interface.0.nat_ip_address} docker swarm join-token -q worker); echo \"#!/usr/bin/env bash\nsudo docker swarm join --token $TOKEN ${yandex_compute_instance.vm-manager[count.index].network_interface.0.nat_ip_address}:2377\nexit 0\" >| join.sh"
  }
}


# Подключемся через Terraform к worker ноде с использованием ключа для присоединения кластеру.
resource "null_resource" "docker-swarm-worker" {
  count = var.workers
  depends_on = [yandex_compute_instance.vm-worker, null_resource.docker-swarm-manager-join]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.vm-worker[count.index].network_interface.0.nat_ip_address
  }

# Копируем локально расположенный скрипт с токеном, созданый на manage ноде, в worker ноду для присоединения к кластеру. 
  provisioner "file" {
    source      = "join.sh"
    destination = "/home/ubuntu/join.sh"
  }

# Устанавливаем на docker, даём права на исполнение скрипта для запуска и запускаем
# https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec
  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://get.docker.com | sh",
      "sudo usermod -aG docker $USER",
      "chmod +x /home/ubuntu/join.sh",
      "/home/ubuntu/join.sh"
    ]
  }
}

# Перепододключемся через Terraform к manage ноде с использованием ключа для деплоя стэка.
resource "null_resource" "docker-swarm-manager-start" {
  depends_on = [yandex_compute_instance.vm-manager, null_resource.docker-swarm-manager-join]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.vm-manager[0].network_interface.0.nat_ip_address
  }

# Деплой проекта магазина из docker-compose.yml на manage ноде по кластеру
# https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec
  provisioner "remote-exec" {
    inline = [
      "docker stack deploy --compose-file /home/ubuntu/docker-compose.yml sockshop-swarm",
      "curl -L https://downloads.portainer.io/ce2-18/portainer-agent-stack.yml -o portainer-agent-stack.yml",
      "docker stack deploy --compose-file portainer-agent-stack.yml portainer"
    ]
  }

# Удаление расположенного локально скрипта присоединения worker ноды к кластеру
# https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec
  provisioner "local-exec" {
    command = "rm -rf join.sh"
  }
}