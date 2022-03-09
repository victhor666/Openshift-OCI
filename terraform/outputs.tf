#Compartimento core
output "Nombre-del-Compartimento-core" {
  description = "Compartimento para elementos core"
  value       = oci_identity_compartment.Core-Compartment.name
}
output "compartimento-core-OCID" {
  description = "OCID del compartimento elementos core"
  value       = oci_identity_compartment.Core-Compartment.id
}
#outputs de red core
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