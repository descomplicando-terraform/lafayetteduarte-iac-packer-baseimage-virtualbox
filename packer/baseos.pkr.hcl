packer {
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }    
  }
}

source "virtualbox-iso" "baseos" {
  boot_wait              = "1s"
  cpus                   = "${var.num_cpus}"
  memory                 = "${var.memory_size}"
  gfx_vram_size          = 128
  gfx_accelerate_3d      = true
  guest_additions_mode   = "upload"
  guest_os_type          = "Ubuntu_64"
  headless               = false
  http_directory         = "./"
  iso_url                = "${var.iso_info.url}"
  iso_checksum           = "${var.iso_info.checksum}"
  ssh_username           = "packer"
  ssh_password           = "packer"
  ssh_read_write_timeout = "600s"
  #ssh_port               = 22
  ssh_timeout      = "120m"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  vm_name          = "${var.image_name}-v${var.image_version}"
  output_directory = "${var.image_path}/${var.image_name}/v${var.image_version}"
  guest_additions_mode = "disable"
  guest_additions_url = "https://download.virtualbox.org/virtualbox/${var.virtualbox_minor_version}/VBoxGuestAdditions_${var.virtualbox_minor_version}.iso"
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--cpu-profile", "host"],
    ["modifyvm", "{{.Name}}", "--nested-hw-virt", "on"],
    ["modifyvm", "{{.Name}}", "--graphicscontroller", "vmsvga"],
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"]
  ]
  boot_command = [
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "<tab><tab><tab><tab><tab><tab><tab><tab><tab><tab><wait>",
    "c<wait5>",
    "set gfxpayload=keep<enter><wait5>",
    "linux /casper/vmlinuz <wait5>",
    "autoinstall quiet fsck.mode=skip noprompt <wait5>",
    "net.ifnames=0 biosdevname=0 systemd.unified_cgroup_hierarchy=1 <wait5>",
    "ds=\"nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/\" <wait5>",
    "---<enter><wait5>",
    "initrd /casper/initrd<enter><wait5>",
    "boot<enter>"
  ]
}

build {
  sources = ["sources.virtualbox-iso.baseos"]

  # TODO: Substituir por um provisionador ansible...
  provisioner "shell" {
    inline = [
      "set -eu",
      "sudo apt update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl gcc hostname iproute2 language-pack-en locales python3 sudo",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential dkms",
      "sudo mount -o loop VBoxGuestAdditions.iso /mnt",
      "(echo 'y' | sudo sh /mnt/VBoxLinuxAdditions.run) || echo $?",
      "sudo umount /mnt"
    ]
  }
  provisioner "ansible" {
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true

    playbook_file = "./ansible/playbook.yml"
    ansible_env_vars = [
      "ANSIBLE_REMOTE_TMP=/tmp/.ansible/tmp",
      "ANSIBLE_CONFIG=ansible/ansible.cfg",
    ]
    roles_path = "./ansible/roles"
    user       = var.user

    #extra_arguments = ["-vvvv"]
  }
}
