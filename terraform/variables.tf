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
variable "CompartmentID" {
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

#Network core
variable "vcn_core_display_name" {
  type = string
}
variable "vcn_core_cidr" {
  type = string
}
variable "vcn_core_dns_label" {
  type = string
}

