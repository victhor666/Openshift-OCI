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
#############################       

    resource "oci_core_default_route_table" "Rt-Cluster" {
      manage_default_resource_id = oci_core_vcn.Vcn-Cluster.default_route_table_id
    
      route_rules {
        destination       = "0.0.0.0/0"
        network_entity_id = oci_core_internet_gateway.Gtw-Cluster.id
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
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }

ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 80
      max = 80
    }
  }
ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 443
      max = 443
    }
  }
}

######################
# Zonas de disponibilidad
######################
    data "oci_identity_availability_domains" "AD1" {
      compartment_id = oci_identity_compartment.Cluster-Compartment.id
    }  
######################
# Subredes
######################

    resource "oci_core_subnet" "Cluster-Subnet" {
      #count               = length(data.oci_identity_availability_domains.AD1.availability_domains)
      availability_domain = ""
     #availability_domain =  lookup(data.oci_identity_availability_domains.AD1.availability_domains[count.index], "name")""
     # cidr_block          = cidrsubnet(var.vcn_cidr, ceil(log(len527gth(data.oci_identity_availability_domains.ad1.availability_domains) * 2, 2)), count.index) <--torbellinos de colores
     # display_name        = "Default Subnet ${lookup(data.oci_identity_availability_domains.ad1.availability_domains[count.index], "name")}"<--torbellinos de colores
      cidr_block     = var.cluster_subnet_cidr
      #cidr_block    = cidrsubnet(var.cluster_subnet_cidr,8,1)
      display_name   = "${var.vcn_cluster_display_name}-Subnet"
      prohibit_public_ip_on_vnic  = false
      dns_label                   = "Openshift"
      compartment_id              = oci_identity_compartment.Cluster-Compartment.id
      vcn_id                      = oci_core_vcn.Vcn-Cluster.id
      route_table_id              = oci_core_default_route_table.Rt-Cluster.id
      security_list_ids           = ["${oci_core_security_list.Cluster-SL.id}"]
      dhcp_options_id             = oci_core_vcn.Vcn-Cluster.default_dhcp_options_id

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
# Servers Centos
######################

