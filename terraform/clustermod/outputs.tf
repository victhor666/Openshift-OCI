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
      value       = oci_core_subnet.Cluster-Subnet[0].cidr_block
    }
        output "dominio_subnet" {
      description = "Nombre dominio dentro de la subnet"
      value       = oci_core_subnet.Cluster-Subnet[0].dns_label
    }
        output "nombre_subnet" {
      description = "Nombre de la Subred "
      value       = oci_core_subnet.Cluster-Subnet[0].display_name
    }
