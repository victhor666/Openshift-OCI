#Compartimento core
output "Nombre-del-Compartimento-core" {
  description = "Compartimento para elementos core"
  value       = oci_identity_compartment.Core-Compartment.name
}

output "vcn_core_cidr" {
  description = "CIDR de la red core "
  value       = oci_core_vcn.Vcn-Core.cidr_block
}
output "vcn_core_Nombre" {
  description = "Nombre de la red Core "
  value       = oci_core_vcn.Vcn-Core.display_name
}
output "vcn_core_DominioDNS" {
  description = "Nombre dominio "
  value       = oci_core_vcn.Vcn-Core.vcn_domain_name
}
#Compartimento cluster
output "vcn_cluster" {
  description = "Nombre dominio "
  value       = oci_core_vcn.Vcn-Cluster.vcn_domain_name
}
output "vcn_cluster_cidr" {
  description = "Nombre dominio "
  value       = oci_core_vcn.Vcn-Cluster.cidr_block
}
output "Master-IP" {
  description = "IP del master"
  value       = oci_core_instance.Master-Instance.private_ip
}
output "Worker1-IP" {
  description = "IP del master"
  value       = oci_core_instance.Master-Instance2.private_ip
}
output "Worker2-IP" {
  description = "IP del master"
  value       = oci_core_instance.Worker-Instance2.private_ip
}
