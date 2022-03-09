#GENERALES
variable "TenancyID" {
  type = string
}
variable "UserID" {
  type = string
}
variable "Region" {
  type = string
}
variable "private_key_path" {
  type = string
}
variable "fingerprint" {
  type = string
}
variable "ssh_public_key" {
  type = string
}
variable "ssh_private_key" {
  type = string
}
variable "core_vcn_cidr"{
  default="192.168.10.0/24"
}

variable "core_subnet_cidr"{
  default="192.168.10.0/28"
}
variable "vcn_core_display_name" {
  type = string
  default="Core-Vcn"
}