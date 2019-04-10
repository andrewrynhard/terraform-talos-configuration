data "template_file" "join" {
  count = "1"

  template = "${file("${path.module}/templates/join.yaml")}"

  vars {
    # Kubernetes

    token               = "${var.kubernetes_token}"
    api_server_endpoint = "${var.api_server_endpoint}"
    taints              = "${var.node_taints}"
    labels              = "node-role.kubernetes.io/${var.node_role}="

    # Talos.

    trustd_username             = "${var.trustd_username}"
    trustd_password             = "${var.trustd_password}"
    trustd_endpoints            = "[ ${join(", ", var.trustd_endpoints)} ]"
    container_network_interface = "${var.container_network_interface_plugin}"
  }
}
