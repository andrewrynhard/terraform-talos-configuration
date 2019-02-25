variable "talos_ca_crt" {
  description = "The PEM encoded Talos certificate"
}

variable "talos_ca_key" {
  description = "The PEM encoded Talos private key"
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

variable "kubernetes_ca_crt" {
  description = "The PEM encoded Kubernetes certificate"
}

variable "kubernetes_ca_key" {
  description = "The PEM encoded Kubernetes private key"
}

variable "master_hostnames" {
  description = "A list of resolvable hostnames used for the master nodes"
  type        = "list"
}

variable "container_network_interface_plugin" {
  description = "The flavor of CNI"
}

variable "cluster_name" {
	description = "The Kubernetes cluster name"
}

variable "dns_domain" {
  description = "The cluster's DNS domain (e.g. cluster.local)"
  default     = "cluster.local"
}

variable "pod_subnet" {
  description = "The CIDR block used for pods"
}

variable "service_subnet" {
  description = "The CIDR block used for Kubernetes services"
}
