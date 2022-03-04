#Cluster VCN

#Network cluster
variable "vcn_cluster_cidr" {
  type = string
}
variable "vcn_cluster_dns_label" {
  type = string
}
variable "vcn_cluster_display_name" {
  type = string
}
variable "Tenancy" {
  type = string
}
#Subnet
variable "cluster_subnet_cidr" {
  type = string
}

#Server
variable "OS" {
  default ="Centos"
}
variable "OS_Version"{
  default = "8"
}
variable "shape"{
  #default = "VM.Standard.E2.1.Micro"
  #default = "VM.Standard.E2.2"
  default = "VM.Standard.E2.1"
}

