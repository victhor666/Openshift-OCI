#######################
# COMPARTIMENTO CLUSTER
#######################

resource "oci_identity_compartment" "Cluster-Compartment" {
  compartment_id = var.TenancyID
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
######################
# lOCAL PEERING CON CORE
###################### 
resource "oci_core_local_peering_gateway" "Peering-VCNCluster" {
   compartment_id = oci_identity_compartment.Cluster-Compartment.id
   vcn_id         = oci_core_vcn.Vcn-Cluster.id
   display_name   = "Peering-Cluster"
 }


#############################
# VCN CLUSTER RUTAS   
#############################
    resource "oci_core_route_table" "Rt-Cluster" {
      compartment_id = oci_identity_compartment.Cluster-Compartment.id
      vcn_id         = oci_core_vcn.Vcn-Cluster.id

      #manage_default_resource_id = oci_core_vcn.Vcn-Cluster.default_route_table_id
      route_rules {
        destination       = "0.0.0.0/0"
        network_entity_id = oci_core_internet_gateway.Gtw-Cluster.id
      }
    route_rules {
        destination       = var.core_vcn_cidr
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_local_peering_gateway.Peering-VCNCluster.id
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

######################
# Subredes
######################
#Publica
resource "oci_core_subnet" "Cluster-Subnet" {
  cidr_block                  = var.cluster_subnet_cidr
  display_name                = "${var.vcn_cluster_display_name}-Subnet"
  dns_label                   = "pub"
  compartment_id              = oci_identity_compartment.Cluster-Compartment.id
  vcn_id                      = oci_core_vcn.Vcn-Cluster.id
  route_table_id              = oci_core_route_table.Rt-Cluster.id
  security_list_ids           = [oci_core_security_list.Cluster-SL.id]
  dhcp_options_id             = oci_core_vcn.Vcn-Cluster.default_dhcp_options_id
  prohibit_public_ip_on_vnic  = false
}
#Privada
resource "oci_core_subnet" "Cluster-Subnet-Priv" {
  cidr_block                      = var.cluster_subnet_priv_cidr
  display_name                    = "${var.vcn_cluster_display_name}-Subnet-Priv"
  dns_label                       = "priv"
  compartment_id                  = oci_identity_compartment.Cluster-Compartment.id
  vcn_id                          = oci_core_vcn.Vcn-Cluster.id
  route_table_id                  = oci_core_route_table.Nat-GW-RT.id
  security_list_ids               = [oci_core_security_list.Cluster-SL.id]
  dhcp_options_id                 = oci_core_vcn.Vcn-Cluster.default_dhcp_options_id
  prohibit_public_ip_on_vnic      = true
}
 

######################
# Servers CentOS
######################
# Zonas de disponibilidad

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
# NODO WORKERS
######################
resource "oci_core_instance" "Worker-Instance1" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.Cluster-Compartment.id
  display_name        = "Worker1"
  shape               = var.shape
  shape_config {
    ocpus = 1
    memory_in_gbs = 8
  }
      metadata = {
        ssh_authorized_keys = file(var.path_local_public_key)
        user_data = base64encode(file(var.path_local_worker_user_data))                             
    } 

  create_vnic_details {
    assign_public_ip = false
    subnet_id        = oci_core_subnet.Cluster-Subnet-Priv.id
    display_name     = "Nic-Worker1"
    hostname_label   = "Worker1"
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
  provisioner "local-exec"{
   command = "sleep 240"
   }
}
##WORKER2 

resource "oci_core_instance" "Worker-Instance2" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.Cluster-Compartment.id
  display_name        = "Worker2"
  shape               = var.shape
  shape_config {
    ocpus = 1
    memory_in_gbs = 8
  }
      metadata = {
        ssh_authorized_keys = file(var.path_local_public_key)
        user_data = base64encode(file(var.path_local_worker_user_data))                             
    } 

  create_vnic_details {
    assign_public_ip = false
    subnet_id        = oci_core_subnet.Cluster-Subnet-Priv.id
    display_name     = "Nic-Worker2"
    hostname_label   = "Worker2"
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
  provisioner "local-exec"{
   command = "sleep 240"
   }
}

#####################
# NODO MASTER
#####################
resource "oci_core_instance" "Master-Instance" {
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
        user_data = base64encode(file(var.path_local_master_user_data))
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
   provisioner "local-exec"{
   command = "sleep 240"
   }
}
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
resource "oci_bastion_session" "BastionSessionWorker1"{
  depends_on                   =[oci_core_instance.Worker-Instance1]
  bastion_id                   = oci_bastion_bastion.BastionService.id
  key_details {
    public_key_content         = file(var.path_local_public_key)
  }
  target_resource_details {
    session_type               = "MANAGED_SSH"
    target_resource_id         = oci_core_instance.Worker-Instance1.id
    target_resource_operating_system_user_name = "opc"
    target_resource_port = 22
    target_resource_private_ip_address = oci_core_instance.Worker-Instance1.private_ip
  }
  display_name = "Acceso worker"
  key_type = "PUB"
  session_ttl_in_seconds = 1800
}
