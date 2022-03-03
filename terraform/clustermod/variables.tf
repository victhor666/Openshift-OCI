#Cluster VCN
variable "vcn_cluster_cidr" {
  type = string
}
variable "vcn_cluster_dns_label" {
  type = string
}
variable "vcn_cluster_display_name" {
  type = string
}

#Subnet
variable "cluster_subnet_cidr" {
  type = string
}
variable "cluster_subnet_display_name" {
  type = string
}

