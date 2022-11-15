# ----------------------------------------------------------------------------------------------------------------------
# AUTHORIZATION
# ----------------------------------------------------------------------------------------------------------------------

variable "subscription_id" {
  type        = string
  description = "Azure Subcription ID."
}

variable "client_id" {
  type        = string
  description = "Service Principal ID."
}

variable "client_secret" {
  type        = string
  description = "Service Princial Password."
}

variable "tenant_id" {
  type        = string
  description = "Azrue Subscription Tenant ID."
}


# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------

variable "resource_group_name" {
  type        = string
  description = "The name of the AKS Cluster resource group."
}

variable "region" {
  type        = string
  description = "The name of the AKS Cluster resource group location."
}

variable "cluster_name" {
  type        = string
  description = "The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created."
}

variable "name_suffix" {
  description = "An arbitrary suffix that will be added to the resource name(s) for distinguishing purposes."
  type        = string
  validation {
    condition     = length(var.name_suffix) <= 14
    error_message = "A max of 14 character(s) are allowed."
  }
}

variable "cluster_vm_size" {
  type        = string
  description = "AKS Cluster VM size."
}

# ----------------------------------------------------------------------------------------------------------------------
# NGINX INGRESS CONTROLLER
# ----------------------------------------------------------------------------------------------------------------------

variable "nginx_helm_name" {
  description = "Release name."
  type        = string
  default     = "inginx-ingress"
}

variable "nginx_helm_repository" {
  description = "Repository URL where to locate the requested chart."
  type        = string
  default     = "https://kubernetes.github.io/ingress-nginx"
}

variable "nginx_helm_chart" {
  description = "Chart name to be installed. The chart name can be local path, a URL to a chart, or the name of the chart if repository is specified. It is also possible to use the <repository>/<chart> format here if you are running Terraform on a system that the repository has been added to with helm repo add but this is not recommended."
  type        = string
  default     = "ingress-nginx"
}

variable "nginx_helm_version" {
  description = "Specify the exact chart version to install. If this is not specified, the latest version is installed."
  type        = string
  default     = "4.3.0"
}

variable "nginx_helm_namespace" {
  description = "The namespace to install the release into. Defaults to default."
  type        = string
  default     = "ingress-nginx"
}

variable "nginx_helm_create_namespace" {
  description = "Create the namespace if it does not yet exist. Defaults to false."
  type        = bool
  default     = true
}

variable "nginx_ingress_controller_replica_count" {
  description = "The number of replicas of the Ingress Controller deployment."
  type        = number
  default     = 1
}

variable "nginx_ingress_controller_node_selector" {
  description = "The node selector for pod assignment for the Ingress Controller pods."
  type        = string
  default     = "linux"
}

variable "nginx_ingress_default_backend_node_selector" {
  description = "The node selector for default backend."
  type        = string
  default     = "linux"
}

variable "nginx_ingress_admission_webhooks_patch_node_selector" {
  description = "The node selector for admission webhooks."
  type        = string
  default     = "linux"
}

variable "nginx_azure_load_balancer_health_request_path" {
  description = "The node selector for admission webhooks."
  type        = string
  default     = "/healthz"
}

variable "nginx_prometheus_scrape" {
  description = "Expose metrics to Prometheus. Defaults to false."
  type        = bool
  default     = true
}

variable "nginx_prometheus_metrics_port" {
  description = "Prometheus metrics port. If this port is changed, change healthz-port: in extraArgs: accordingly"
  type        = string
  default     = "10254"
}

variable "nginx_external_traffic_policy" {
  description = "Set external traffic policy to: Local to preserve source IP on providers supporting it."
  type        = string
  default     = "Local"
}

variable "nginx_ingress_controller_metrics_enabled" {
  description = "If this port is changed, change healthz-port: in extraArgs: accordingly"
  type        = bool
  default     = true
}

variable "nginx_ingress_controller_metrics_service_monitor_enabled" {
  description = "Enable to scrape Prometheus metrics. Default to false."
  type        = bool
  default     = true
}

variable "nginx_ingress_controller_metrics_service_monitor_additional_labels" {
  description = "The label to use to retrieve the job name from."
  type        = string
  default     = "prometheus"
}