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