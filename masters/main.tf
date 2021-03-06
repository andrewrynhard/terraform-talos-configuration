locals {
  joining_master_hostnames = "${slice(var.master_hostnames, 1, length(var.master_hostnames))}"
}

data "template_file" "init" {
  count = "1"

  template = "${file("${path.module}/templates/init.yaml")}"

  vars {
    # Kubernetes.

    kubernetes_ca_crt      = "${base64encode(var.kubernetes_ca_crt)}"
    kubernetes_ca_key      = "${base64encode(var.kubernetes_ca_key)}"
    token                  = "${var.kubernetes_token}"
    certificate_key        = "${var.kubernetes_certificate_key}"
    api_server_cert_sans   = "${join(", ", var.master_hostnames)}"
    api_endpoint           = "${var.master_hostnames[count.index]}"
    control_plane_endpoint = "${var.master_hostnames[0]}"
    taints                 = ""
    labels                 = ""
    cluster_name           = "${var.cluster_name}"
    dns_domain             = "${var.dns_domain}"
    pod_subnet             = "${var.pod_subnet}"
    service_subnet         = "${var.service_subnet}"

    # Talos.

    os_ca_crt                   = "${base64encode(var.talos_ca_crt)}"
    os_ca_key                   = "${base64encode(var.talos_ca_key)}"
    trustd_username             = "${var.trustd_username}"
    trustd_password             = "${var.trustd_password}"
    trustd_endpoints            = "[ ${join(", ", slice(var.master_hostnames, 1, length(var.master_hostnames)))} ]"
    container_network_interface = "${var.container_network_interface_plugin}"
  }
}

data "template_file" "join" {
  count = 2

  template = "${file("${path.module}/templates/join.yaml")}"

  vars {
    # Kubernetes.

    kubernetes_ca_crt      = "${base64encode(var.kubernetes_ca_crt)}"
    kubernetes_ca_key      = "${base64encode(var.kubernetes_ca_key)}"
    token                  = "${var.kubernetes_token}"
    certificate_key        = "${var.kubernetes_certificate_key}"
    api_server_cert_sans   = "${join(", ", var.master_hostnames)}"
    api_endpoint           = "${local.joining_master_hostnames[count.index]}"
    control_plane_endpoint = "${var.master_hostnames[0]}"
    taints                 = ""
    labels                 = ""
    cluster_name           = "${var.cluster_name}"
    dns_domain             = "${var.dns_domain}"
    pod_subnet             = "${var.pod_subnet}"
    service_subnet         = "${var.service_subnet}"

    # Talos.

    os_ca_crt                   = "${base64encode(var.talos_ca_crt)}"
    os_ca_key                   = "${base64encode(var.talos_ca_key)}"
    trustd_username             = "${var.trustd_username}"
    trustd_password             = "${var.trustd_password}"
    trustd_endpoints            = "[ ${var.master_hostnames[0]} ]"
    trustd_bootstrap_node       = "${var.master_hostnames[0]}"
    container_network_interface = "${var.container_network_interface_plugin}"
  }
}

