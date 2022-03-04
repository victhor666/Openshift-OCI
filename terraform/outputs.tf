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
  #outputs de red cluster
    output "vcn_cluster_cidr" {
      description = "CIDR de la red core "
      value       = module.clustermod.cidr_vcn
    }
    output "vcn_nombre_Nombre" {
      description = "Nombre de la red Core "
      value       = module.clustermod.nombre_vcn
    }
    output "vcn_cluster_DominioDNS" {
      description = "Nombre dominio cluster"
      value       = module.clustermod.dominio_vcn
    }
     #outputs de Subred cluster
        output "vcn_cluster_cidr" {
      description = "CIDR de la Subred core "
      value       = module.clustermod.cidr_subnet
    }
    output "vcn_nombre_Nombre" {
      description = "Nombre de la Subred Core "
      value       = module.clustermod.nombre_subnet
    }
    output "vcn_cluster_DominioDNS" {
      description = "Nombre dominio Subred cluster"
      value       = module.clustermod.dominio_subnet
    }
    
