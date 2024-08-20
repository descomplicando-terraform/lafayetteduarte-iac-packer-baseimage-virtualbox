
variable "packer_hashed_password" {
  type      = string
  default   = "packer"
  sensitive = true
}

variable "baseos_version" {
  type    = string
  default = env("IMAGE_VERSION") != "" ? env("IMAGE_VERSION")  : "1"
}

variable "image_path" {
  type    = string
  default = env("IMAGE_PATH") != "" ? env("IMAGE_PATH") : "../images"
}

variable "iso_info" {
  type = object({
    url      = string
    checksum = string
  })
  default = {
    url      = "http://releases.ubuntu.com/22.04.4/ubuntu-22.04.4-live-server-amd64.iso"
    checksum = "45f873de9f8cb637345d6e66a583762730bbea30277ef7b32c9c3bd6700a32b2"
  }
}

variable num_cpus {
  type    = number
  default = 2
}

variable memory_size {
  type    = number
  default = 2048
}
