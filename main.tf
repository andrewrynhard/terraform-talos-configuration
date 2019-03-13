locals {
  joining_master_hostnames = "${slice(var.master_hostnames, 1, length(var.master_hostnames))}"
}

data "template_file" "init_master" {
  count = "1"

  template = "${file("${path.module}/templates/init.yaml")}"

  vars {
    # Kubernetes.

    kubernetes_ca_crt      = "${base64encode(var.kubernetes_ca_crt)}"
    kubernetes_ca_key      = "${base64encode(var.kubernetes_ca_key)}"
    token                  = "${var.kubernetes_token}"
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
    trustd_endpoints            = "[${join(", ", slice(var.master_hostnames, 1, length(var.master_hostnames)))}]"
    trustd_next                 = "${length(var.master_hostnames) > 1 ? element(var.master_hostnames, 1) : ""}"
    container_network_interface = "${var.container_network_interface_plugin}"
  }
}

data "template_file" "join_master" {
  count = "${length(local.joining_master_hostnames)}"

  template = "${file("${path.module}/templates/join-control-plane.yaml")}"

  vars {
    # Kubernetes.

    kubernetes_ca_crt      = "${base64encode(var.kubernetes_ca_crt)}"
    kubernetes_ca_key      = "${base64encode(var.kubernetes_ca_key)}"
    token                  = "${var.kubernetes_token}"
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
    trustd_endpoints            = "[${var.master_hostnames[0]}]"
    trustd_next                 = "${length(local.joining_master_hostnames) - 1 == count.index ? "" : element(local.joining_master_hostnames, count.index + 1)}"
    container_network_interface = "${var.container_network_interface_plugin}"
  }
}

data "template_file" "worker" {
  count = "1"

  template = "${file("${path.module}/templates/join-worker.yaml")}"

  vars {
    # Kubernetes.

    kubernetes_ca_crt      = "${base64encode(var.kubernetes_ca_crt)}"
    kubernetes_ca_key      = "${base64encode(var.kubernetes_ca_key)}"
    token                  = "${var.kubernetes_token}"
    api_server_cert_sans   = "${join(", ", var.master_hostnames)}"
    api_endpoint           = "${var.master_hostnames[0]}"
    control_plane_endpoint = "${var.master_hostnames[0]}"
    master_ip              = "${var.master_hostnames[0]}"
    taints                 = ""
    labels                 = "node-role.kubernetes.io/worker="
    cluster_name           = "${var.cluster_name}"
    dns_domain             = "${var.dns_domain}"
    pod_subnet             = "${var.pod_subnet}"
    service_subnet         = "${var.service_subnet}"

    # Talos.

    trustd_username             = "${var.trustd_username}"
    trustd_password             = "${var.trustd_password}"
    trustd_endpoints            = "[${join(", ", var.master_hostnames)}]"
    container_network_interface = "${var.container_network_interface_plugin}"
  }
}
