# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.define "worker" do |node|
    config.vm.network "private_network", ip: "192.168.56.201"
    node.vm.hostname = "worker-node01"
    node.vm.provider "virtualbox" do |vb|
        vb.name = "worker-node01"
        vb.memory = 2048
        vb.cpus = 2
    end
  end

  # Chạy các lệnh shell
  config.vm.provision "shell", inline: <<-SHELL
    # Đặt pass 123 có tài khoản root và cho phép SSH
    useradd truonglm
    usermod -aG sudo truonglm
    #usermod -aG docker truonglm
    echo "truonglm:123" | sudo chpasswd
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    systemctl reload sshd
    # Ghi nội dung sau ra file /etc/hosts để truy cập được các máy theo HOSTNAME
      echo "192.168.56.200 master-ubuntu" >> /etc/hosts
      echo "192.168.56.201 worker-node1-ubuntu" >> /etc/hosts

    #cài đặt docker và kubernetes
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt install docker.io -y
    usermod -aG docker truonglm
  SHELL
end

