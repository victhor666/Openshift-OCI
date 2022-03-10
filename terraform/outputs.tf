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

output "cidr_vcn" {
  description = "CIDR de la red Cluster "
  value       = oci_core_vcn.Vcn-Cluster.cidr_block
}
output "nombre_vcn" {
  description = "Nombre de la red Cluster "
  value       = oci_core_vcn.Vcn-Cluster.display_name
}
output "dominio_vcn" {
  description = "Nombre dominio cluster"
  value       = oci_core_vcn.Vcn-Cluster.dns_label
}
    output "cidr_subnet" {
  description = "CIDR de la subred del  Cluster "
  value       = oci_core_subnet.Cluster-Subnet.cidr_block
}
    output "dominio_subnet" {
  description = "Nombre dominio dentro de la subnet"
  value       = oci_core_subnet.Cluster-Subnet.dns_label
}
    output "nombre_subnet" {
  description = "Nombre de la Subred "
  value       = oci_core_subnet.Cluster-Subnet.display_name
}
  output "Nombre_maquina_Worker1" {
  description = "Nombre maquina Worker1 "
  value       = oci_core_instance.Worker-Instance1.display_name
}
  output "nombre_maquina_infra" {
  description = "Nombre maquina Worker2 "
  value       = oci_core_instance.Worker-Instance2.display_name
}
output "Master-IP" {
  description = "IP del master"
  value       = oci_core_instance.Master-Instance.private_ip
}
output "Worker1-IP" {
  description = "IP del master"
  value       = oci_core_instance.Worker-Instance2.private_ip
}
output "Worker2-IP" {
  description = "IP del master"
  value       = oci_core_instance.Worker-Instance2.private_ip
}
