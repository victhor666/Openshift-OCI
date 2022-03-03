#####################################
#Definicion del proveedor y conexion
#####################################
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
  freeform_tags = {"Propietario"= "Infra",
                   "Funcion"="Conectividad"
          }
}

#################
# VCN CORE
#################
    
    resource oci_core_vcn "vcnterra" {
      dns_label      = var.vcn_core_dns_label
      cidr_block     = var.vcn_core_cidr
      compartment_id = oci_identity_compartment.Core-Compartment.id
      display_name   = var.vcn_core_display_name
    }