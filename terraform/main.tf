terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.92"
}

provider "yandex" {
  token     = "y0_AgAAAABo73ExAATuwQAAAADkhTi6awY5q-aWT72wd6W0YPWBGrNRLsM"
  cloud_id  = "b1gm6rc74jl2j8r4n1n0"
  folder_id = "b1gm6rc74jl2j8r4n1n0"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "srv" {
  name = "srv"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd83vhe8fsr4pe98v6oj"
      size     = 20
    }
  }

  metadata = {
    user-data = "root:${file("./meta.yml")}"
  }

  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname srv"]
  }

  connection {
    host = yandex_compute_instance.srv.network_interface.0.nat_ip_address
    type = "ssh"
    user = "root"
    private_key = "${file("./meta.yml")}"
  }

  network_interface {
    subnet_id = "e9bkad5fmqruihg0r70h"
    nat       = true
    }
}

resource "yandex_compute_instance" "k8s-master" {
  name = "k8s-master"

  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname k8s-master"]
  }


  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd83vhe8fsr4pe98v6oj"
      size     = 20
    }
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }
  network_interface {
    subnet_id = "e9bkad5fmqruihg0r70h"
    nat       = true
    }
}

resource "yandex_vpc_address" "test-ip" {
  name = "exampleAddress"

  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

resource "yandex_compute_instance" "k8s-node" {
  name = "k8s-node"

  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname k8s-node"]
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd83vhe8fsr4pe98v6oj"
      size     = 20
    }
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

  network_interface {
    subnet_id = "e9bkad5fmqruihg0r70h"
    nat       = true
    }
 }
  output "internal_ip_address_srv" {
    value = yandex_compute_instance.srv.network_interface.0.ip_address
  }

  output "external_ip_address_srv" {
    value = yandex_compute_instance.srv.network_interface.0.nat_ip_address
  }

  output "internal_ip_address_k8s-master" {
    value = yandex_compute_instance.k8s-master.network_interface.0.ip_address
  }

  output "external_ip_address_k8s-master" {
    value = yandex_compute_instance.k8s-master.network_interface.0.nat_ip_address
  }

  output "internal_ip_address_k8s-node" {
    value = yandex_compute_instance.k8s-node.network_interface.0.ip_address
  }

  output "external_ip_address_k8s-node" {
    value = yandex_compute_instance.k8s-node.network_interface.0.nat_ip_address
  }  
