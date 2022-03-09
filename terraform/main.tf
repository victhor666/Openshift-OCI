#####################################
#Definicion del proveedor y conexion
#####################################
terraform {
  required_providers {
    oci = {
      source = "hashicorp/oci"
      version = "4.65.0"
    }
  }
}
provider "oci" {
  tenancy_ocid     = var.TenancyID
  user_ocid        = var.UserID
  private_key_path = "~/Openshift-OCI/clave.pem"
  fingerprint      = var.fingerprint
  region           = var.Region
}

#Creando recursos basicos
#################################
# COMPARTIMENTO ELEMENTOS CORE
#################################
resource "oci_identity_compartment" "Core-Compartment" {
  compartment_id = var.TenancyID
  description    = "Compartimento para recursos de Openshift."
  # New Compartment Name
  name = "Core-Openshift"
  freeform_tags = { "Propietario" = "Infra",
    "Funcion" = "Conectividad"
  }
}

#################
# VCN CORE
#################
    
resource oci_core_vcn "Vcn-Core" {
  compartment_id = oci_identity_compartment.Core-Compartment.id
  dns_label      = "CoreNet"
  cidr_block     = var.core_vcn_cidr
  display_name   = var.vcn_core_display_name
  freeform_tags = {"Propietario"= "Infra",
                   "Funcion"="Conectividad"}
}

resource "oci_core_subnet" "Core-Subnet" {
  cidr_block                  = var.core_subnet_cidr
  display_name                = "${var.vcn_core_display_name}-Subnet"
  dns_label                   = "Bastion"
  compartment_id              = oci_identity_compartment.Cluster-Compartment.id
  vcn_id                      = oci_core_vcn.Vcn-Cluster.id
  route_table_id              = oci_core_default_route_table.Rt-Cluster.id
  security_list_ids           = [oci_core_security_list.Cluster-SL.id]
  dhcp_options_id             = oci_core_vcn.Vcn-Cluster.default_dhcp_options_id
  prohibit_public_ip_on_vnic  = false
}

# Peering en VNC core
# resource "oci_core_local_peering_gateway" "Peering-VCNCore" {
#   compartment_id = oci_identity_compartment.Core-Compartment.id
#   vcn_id         = oci_core_vcn.Vcn-Core.id
#   display_name   = "Peering-Core"
#   peer_id        = oci_core_local_peering_gateway.Peering-VCNCore.id
# }

# # Rutas para el peering
# resource "oci_core_route_table" "Peering-RTCore" {
#   compartment_id = oci_identity_compartment.Core-Compartment.id
#   vcn_id         = oci_core_vcn.Vcn-Core.id
#   display_name   = "Tabla Rutas Peering en Core"
#   route_rules {
#     destination       = "192.168.50.0/24"
#     destination_type  = "CIDR_BLOCK"
#     network_entity_id = module.Cluster.data.network_indentity_cluster
#   }
# }     


