
variable "packer_hashed_password" {
  type      = string
  default   = "packer"
  sensitive = true
}

variable "user" {
  type        = string
  description = "Usuário default"
  default     = "packer"
}

variable "image_version" {
  type    = string
  default = env("IMAGE_VERSION") != "" ? env("IMAGE_VERSION") : "1"
}


variable "image_name" {
  type    = string
  default = env("IMAGE_NAME") != "" ? env("IMAGE_NAME") : "baseOS"
}

variable "image_path" {
  type    = string
  default = env("IMAGE_PATH") != "" ? env("IMAGE_PATH") : "final-image"
}

variable "iso_info" {
  type = object({
    url      = string
    checksum = string
  })
  default = {
    url      = "https://releases.ubuntu.com/22.04.5/ubuntu-22.04.5-live-server-amd64.iso"
    checksum = "9bc6028870aef3f74f4e16b900008179e78b130e6b0b9a140635434a46aa98b0"
  }
}


variable "virtualbox_minor_version" {
  type    = string
  default = env("VIRTUALBOX_MINOR_VERSION") != "" ? env("VIRTUALBOX_MINOR_VERSION") : "7.1.14"
}

variable num_cpus {
  type    = number
  default = 2
}

variable memory_size {
  type    = number
  default = 2048
}
