#Definicion del proveedor

provider "oci" {
  tenancy_ocid     = var.TenancyID
  user_ocid        = var.UserID
  private_key_path = "~/Openshift-OCI/clave.pem"
  fingerprint      = var.fingerprint
  region           = var.Region
}

#Creando recursos basicos
# compartimento
resource "oci_identity_compartment" "OPS-Compartment" {
  compartment_id = var.TenancyID
  description    = "Compartimento para recursos de Openshift."
  # New Compartment Name
  name = "Oci-Openshift"
}