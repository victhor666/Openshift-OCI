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
  compartment_id              = oci_identity_compartment.Core-Compartment.id
  vcn_id                      = oci_core_vcn.Vcn-Core.id
  route_table_id              = oci_core_default_route_table.Rt-Core.id
  security_list_ids           = [oci_core_security_list.Core-SL.id]
  dhcp_options_id             = oci_core_vcn.Vcn-Core.default_dhcp_options_id
  prohibit_public_ip_on_vnic  = false
}
#########################
# VCN CORE SECURITY LISTS
#########################
resource "oci_core_security_list" "Core-SL" {
  compartment_id = oci_identity_compartment.Core-Compartment.id
  vcn_id = oci_core_vcn.Vcn-Core.id
  display_name = "Cluster-Security-List-Basica"
  egress_security_rules {
     protocol    = "all"
    destination = "0.0.0.0/0"
  }
      dynamic "ingress_security_rules" {
    for_each = var.puertos_entrada
    content {
      protocol = "6"
      source   = "0.0.0.0/0"
      tcp_options {
        max = ingress_security_rules.value
        min = ingress_security_rules.value
      }
    }
  }
}
#########################
# VCN CORE GATEWAY
#########################
    resource oci_core_internet_gateway "Gtw-Core" {
      compartment_id = oci_identity_compartment.Core-Compartment.id
      vcn_id         = oci_core_vcn.Vcn-Core.id 
      display_name = "Core-IGW"
      enabled = "true"
    }

#########################
# VCN CORE RUTAS
#########################
resource "oci_core_default_route_table" "Rt-Core" {
  manage_default_resource_id = oci_core_vcn.Vcn-Core.default_route_table_id
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.Gtw-Core.id
  }
    route_rules {
    destination       = var.vcn_cluster_cidr
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_local_peering_gateway.Peering-VCNCore.id
  }
}


#########################
# VCN CORE PEERING
#########################
resource "oci_core_local_peering_gateway" "Peering-VCNCore" {
  compartment_id = oci_identity_compartment.Core-Compartment.id
  vcn_id         = oci_core_vcn.Vcn-Core.id
  display_name   = "Peering-Core"
  peer_id        = oci_core_local_peering_gateway.Peering-VCNCluster.id
}


#################
# TEST SERVER 
#################
    
resource "oci_core_instance" "Test" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.Core-Compartment.id
  display_name        = "Test"
  shape               = var.shape
  shape_config {
    ocpus = 1
    memory_in_gbs = 8
  }
      metadata = {
        ssh_authorized_keys = file(var.path_local_public_key)
    } 

  create_vnic_details {
    assign_public_ip = false
    subnet_id        = oci_core_subnet.Core-Subnet.id
    display_name     = "Nic-Test"
    hostname_label   = "TestNic"
  }

  source_details {
    source_type = "image"
    source_id = data.oci_core_images.OSImage.images.0.id
  }

  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled = false
    is_monitoring_disabled = true
    plugins_config {
        name = "Bastion"
        desired_state = "ENABLED"
      }
  }

}

