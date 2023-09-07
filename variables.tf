variable "instance_name" {
  type    = string
  default = "terraform-auto-machine"
}


variable "volume_type" {
  type    = string
  default = "gp2"
}
variable "volume_size" {
  type    = number
  default = 8
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_ami" {
  type    = string
  default = "ami-0f5ee92e2d63afc18"

}

variable "key_pair_name" {
  type    = string
  default = "terraform-key-pair"
}

variable "inbound_ports" {
  type    = list(number)
  default = [22, 80, 443, 8000]
}
