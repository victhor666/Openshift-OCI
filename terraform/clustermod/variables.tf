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

variable "Image_ID"{
  #default = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaaejpci3y3yezvhvaxdez6nui7vdsfyny4rxnpitvq6xdue33g52aq"
  #centos7
  default ="ocid1.image.oc1.eu-amsterdam-1.aaaaaaaaipu6pm6lv6x4nmgorayhw43tqh5tuy55zkjasdjddjw6zkcuasxq"
  #rhcos
  #default="ocid1.image.oc1.eu-amsterdam-1.aaaaaaaafxjjmi2g4blliilpxwc63xmzwte3nu6uxvfs7v5qaant2h3olenq"
}
variable "path_local_public_key" {
  default = "~/Openshift-OCI/linuxuser.pub"
  sensitive = true
}
# variable "path_local_master_user_data" {
#   default = "~/Openshift-OCI/master_user_data.sh"
# }
variable "path_local_infra_user_data" {
  default = "~/Openshift-OCI/infra_user_data.sh"
}