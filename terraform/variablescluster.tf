#Cluster VCN

#Network cluster
variable "vcn_cluster_cidr" {
  type = string
  default="192.168.50.0/24"
}
variable "vcn_cluster_dns_label" {
  type = string
  default="ClusterNet"
}
variable "vcn_cluster_display_name" {
  type = string
  default="Cluster-Vcn"
}

#Subnet Publica
variable "cluster_subnet_cidr" {
  type = string
  default="192.168.50.16/28"
}
variable "cluster_subnet_priv_cidr" {
  type = string
  default="192.168.50.0/28"
}

variable "shape"{
  #default = "VM.Standard.E2.1.Micro"
  #default = "VM.Standard.E2.2"
  default = "VM.Standard.E2.2"
}

#variable "Image_ID"{
  #default = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaaejpci3y3yezvhvaxdez6nui7vdsfyny4rxnpitvq6xdue33g52aq"
  #centos7
  #default ="ocid1.image.oc1.eu-amsterdam-1.aaaaaaaaipu6pm6lv6x4nmgorayhw43tqh5tuy55zkjasdjddjw6zkcuasxq"
  #rhcos
  #default="ocid1.image.oc1.eu-amsterdam-1.aaaaaaaafxjjmi2g4blliilpxwc63xmzwte3nu6uxvfs7v5qaant2h3olenq"
  #}
variable "path_local_public_key" {
  default = "~/Openshift-OCI/linuxuser.pub"
  sensitive = true
}
 variable "path_local_master_user_data" {
   default = "~/Openshift-OCI/master_user_data.sh"
 }
variable "path_local_worker_user_data" {
  default = "~/Openshift-OCI/worker_user_data.sh"
}
variable "puertos_entrada"{
  default=[22,80,443,8443]
}
variable "sistema_operativo"{
  default ="Canonical Ubuntu"
}
variable "version_os"{
  default= "20.04"
}