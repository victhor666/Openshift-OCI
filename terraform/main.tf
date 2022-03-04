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
      cidr_block     = "192.168.10.0/24"
      display_name   = "Vcn-Core"
      freeform_tags = {"Propietario"= "Infra",
                       "Funcion"="Conectividad"}
    }
#################
# MODULO CLUSTER1
#################
module "Cluster" {
  source                    = "./clustermod"
  Tenancy                   = "ocid1.tenancy.oc1..aaaaaaaaitp7vjo25jff4ehr7lkaztezse4qtdjluduaw56pnxkbsxyiyjgq"
  vcn_cluster_cidr          = "192.168.50.0/24"
  vcn_cluster_dns_label     = "ClusterNet"
  vcn_cluster_display_name  = "Cluster-Vcn"
  cluster_subnet_cidr       = "192.168.50.0/28"
}