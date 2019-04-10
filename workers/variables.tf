variable "node_role" {
  description = "The node's role"
}

variable "node_taints" {
  description = "The trustd username"
  default     = "[]"
}

variable "trustd_username" {
  description = "The trustd username"
}

variable "trustd_password" {
  description = "The trustd password"
}

variable "trustd_endpoints" {
  description = "The list of IP addresses to use for the trustd API"
  type        = "list"
}

variable "kubernetes_token" {
  description = "The kubeadm token"
}

variable "api_server_endpoint" {
  description = "The API server URL"
}

variable "container_network_interface_plugin" {
  description = "The flavor of CNI"
}
