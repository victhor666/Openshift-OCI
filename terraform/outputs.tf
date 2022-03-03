#Compartimento core
output "Nombre-del-Compartimento-core" {
  value = oci_identity_compartment.Core-Compartment.name
}
output "compartimento-core-OCID" {
  value = oci_identity_compartment.Core-Compartment.id
}
#outputs de red core
    output "vcn_core_id" {
      description = "OCID de la vnc de core. "
      value       = oci_core_vcn.vcncore.id
    }
