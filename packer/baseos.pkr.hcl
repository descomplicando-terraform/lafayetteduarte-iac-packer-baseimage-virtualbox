packer {
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

source "virtualbox-iso" "baseos" {
  boot_wait              = "1s"
  cpus                   = 2
  memory                 = 2048
  gfx_vram_size          = 128
  gfx_accelerate_3d      = true
  guest_additions_mode   = "upload"
  guest_os_type          = "Ubuntu_64"
  headless               = false
  http_directory         = "./"
  iso_url                = "http://releases.ubuntu.com/22.04.4/ubuntu-22.04.4-live-server-amd64.iso"
  iso_checksum           = "45f873de9f8cb637345d6e66a583762730bbea30277ef7b32c9c3bd6700a32b2"
  ssh_username           = "packer"
  ssh_password           = "packer"
  ssh_read_write_timeout = "600s"
  #ssh_port               = 22
  ssh_timeout      = "120m"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
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
}


