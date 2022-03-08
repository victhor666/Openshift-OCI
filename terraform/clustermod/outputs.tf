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
        output "nombre_maquina_infra" {
      description = "Nombre maquina infraestructura "
      value       = oci_core_instance.Infra-Instance.display_name
    }
    #         output "nombre_maquina_master" {
    #   description = "Nombre maquina master "
    #   value       = oci_core_instance.Master-Instance.display_name
    # }
    #             output "nombre_maquina_worker" {
    #   description = "Nombre maquina worker "
    #   value       = oci_core_instance.Worker-Instance.display_name
    # }

   output "imagen_nombre" {
  value = data.oci_core_images.OSImage.0.display_name
}
output "imagen_id" {
  value = data.oci_core_images.OSImage.0.id
}