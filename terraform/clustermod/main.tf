#######################
# COMPARTIMENTO CLUSTER
#######################

resource "oci_identity_compartment" "Cluster-Compartment" {
  compartment_id = var.Tenancy
  description    = "Compartimento para recursos del cluster."
  # New Compartment Name
  name = "Cluster-Openshift"
  freeform_tags = { "Propietario" = "Cluster",
    "Funcion" = "Openshift-cluster"
  }
}

#################
# VCN CLUSTER
#################
    
    resource oci_core_vcn "Vcn-Cluster" {
      dns_label      = var.vcn_cluster_dns_label
      cidr_block     = var.vcn_cluster_cidr
      compartment_id = oci_identity_compartment.Cluster-Compartment.id
      display_name   = var.vcn_cluster_display_name
    }
######################
# Internet Gateway
######################    
    resource oci_core_internet_gateway "Gtw-Cluster" {
      compartment_id = oci_identity_compartment.Cluster-Compartment.id
      vcn_id         = oci_core_vcn.Vcn-Cluster.id 
      display_name = "Cluster-IGW"
      enabled = "true"
    }
#############################
# Tabla de rutas por defecto   

    resource "oci_core_default_route_table" "Rt-Cluster" {
      manage_default_resource_id = oci_core_vcn.Vcn-Cluster.default_route_table_id
    
      route_rules {
        destination       = "0.0.0.0/0"
        network_entity_id = oci_core_internet_gateway.Gtw-Cluster.id
      }
    }

#####################
# NAT Gateway
#####################
resource "oci_core_nat_gateway" "Nat-GW" {
  compartment_id = oci_identity_compartment.Cluster-Compartment.id
  vcn_id         = oci_core_vcn.Vcn-Cluster.id
  display_name   = "Nat-GW para instancias sin acceso exterior"
}
# Route Table for NAT
resource "oci_core_route_table" "Nat-GW-RT" {
  compartment_id = oci_identity_compartment.Cluster-Compartment.id
  vcn_id         = oci_core_vcn.Vcn-Cluster.id
  display_name   = "Tabla de rutas via NAT"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.Nat-GW.id
  }
}

######################
# Security Lists
######################

resource "oci_core_security_list" "Cluster-SL" {
  compartment_id = oci_identity_compartment.Cluster-Compartment.id
  vcn_id = oci_core_vcn.Vcn-Cluster.id
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
  ingress_security_rules {
    source      = "0.0.0.0/0"
    protocol    = "1"
     icmp_options {
      type = 3
      code = 4
    }
  }
}

#############################
# Zonas de disponibilidad
#############################
    data "oci_identity_availability_domains" "AD1" {
      compartment_id = oci_identity_compartment.Cluster-Compartment.id
    }  
######################
# Subredes
######################
#Publica
    resource "oci_core_subnet" "Cluster-Subnet" {
      cidr_block                  = var.cluster_subnet_cidr
      display_name                = "${var.vcn_cluster_display_name}-Subnet"
      dns_label                   = "Openshift"
      compartment_id              = oci_identity_compartment.Cluster-Compartment.id
      vcn_id                      = oci_core_vcn.Vcn-Cluster.id
      route_table_id              = oci_core_default_route_table.Rt-Cluster.id
      security_list_ids           = [oci_core_security_list.Cluster-SL.id]
      dhcp_options_id             = oci_core_vcn.Vcn-Cluster.default_dhcp_options_id
      prohibit_public_ip_on_vnic  = false
    }
#Privada
resource "oci_core_subnet" "Cluster-Subnet-Priv" {
  cidr_block                      = var.cluster_subnet_priv_cidr
  display_name                    = "${var.vcn_cluster_display_name}-Subnet-Priv"
  dns_label                       = "Openshiftpriv"
  compartment_id                  = oci_identity_compartment.Cluster-Compartment.id
  vcn_id                          = oci_core_vcn.Vcn-Cluster.id
  route_table_id                  = oci_core_route_table.Nat-GW-RT.id
  security_list_ids               = [oci_core_security_list.Cluster-SL.id]
  dhcp_options_id                 = oci_core_vcn.Vcn-Cluster.default_dhcp_options_id
  prohibit_public_ip_on_vnic      = true
}
 
######################
# Peering  
######################
#  resource "oci_core_local_peering_gateway" "Cluster-Peering" {
#     compartment_id = oci_identity_compartment.Cluster-Compartment.id
#     vcn_id = oci_core_vcn.Vcn-Core.id
#     defined_tags = {"Operations.CostCenter"= "42"}
#     display_name = "Peering con core network"
# }
######################
# Servers CentOS
######################

data "oci_identity_availability_domain" "ad" {
  compartment_id = oci_identity_compartment.Cluster-Compartment.id
  ad_number      = 1
}


######################
# IMAGEN
######################

data "oci_core_images" "OSImage" {
  compartment_id           = oci_identity_compartment.Cluster-Compartment.id
  operating_system         = var.sistema_operativo
  operating_system_version = var.version_os
  sort_by = "TIMECREATED"
  sort_order = "DESC"
}

######################
# NODO INFRA
######################
resource "oci_core_instance" "Infra-Instance" {
  #count               = var.num_instances
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.Cluster-Compartment.id
  display_name        = "Infra"
  shape               = var.shape
  shape_config {
    ocpus = 1
    memory_in_gbs = 8
  }
      metadata = {
        ssh_authorized_keys = file(var.path_local_public_key)
        user_data = base64encode(file(var.path_local_infra_user_data))
                                       
    } 

  create_vnic_details {
    assign_public_ip = false
    subnet_id        = oci_core_subnet.Cluster-Subnet-Priv.id
    display_name     = "Nic-Infra"
    hostname_label   = "Infraestructura"
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
#####################
# NODO MASTER
#####################
resource "oci_core_instance" "Master-Instance" {
  #count               = var.num_instances
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.Cluster-Compartment.id
  display_name        = "Master"
  shape               = var.shape
  shape_config {
    ocpus = 1
    memory_in_gbs = 8
  }
      metadata = {
        ssh_authorized_keys = file(var.path_local_public_key)
        user_data = base64encode(file(var.path_local_infra_user_data))
    } 

  create_vnic_details {
    subnet_id        = oci_core_subnet.Cluster-Subnet.id
    display_name     = "Nic-Master"
    assign_public_ip = true
    hostname_label   = "Master"
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
######################
# NODOS WORKER
######################


######################
# SERVICIO BASTION
######################
resource "oci_bastion_bastion" "BastionService" {
  bastion_type                 = "STANDARD"
  compartment_id               = oci_identity_compartment.Cluster-Compartment.id
  target_subnet_id             = oci_core_subnet.Cluster-Subnet.id
  client_cidr_block_allow_list = ["0.0.0.0/0"]
  name                         ="BastionService"
  max_session_ttl_in_seconds   = 1800
}
resource "oci_bastion_session" "BastionSession"{
  bastion_id                   = oci_bastion_bastion.BastionService.id
  key_details {
    public_key_content         = file(var.path_local_public_key)
  }
  target_resource_details {
    session_type               = "MANAGED_SSH"
    target_resource_id         = oci_core_instance.Infra-Instance.id
    target_resource_operating_system_user_name = "opc"
    target_resource_port = 22
    target_resource_private_ip_address = oci_core_instance.Infra-Instance.private_ip
  }
  display_name = "AccesoViaBastion"
  key_type = "PUB"
  session_ttl_in_seconds = 1800
}