terraform {
  required_version = ">= 1.3.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.29.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

locals {
  cluster_name = format("aks-%s-%s", var.cluster_name, var.name_suffix)
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = local.cluster_name
  location            = var.region
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name

  default_node_pool {
    name                = "default"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 5
    vm_size             = var.cluster_vm_size
  }

  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_container_registry" "container_registry" {
  name                = var.container_registry
  resource_group_name = var.acr_resource_group_name
}

resource "azurerm_role_assignment" "acr_role_assignment" {
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.container_registry.id
  skip_service_principal_aad_check = true

  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
}

# https://github.com/hashicorp/terraform-provider-helm
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)
  }
}

# https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx
resource "helm_release" "nginx_ingress_controller" {
  name             = var.nginx_helm_name
  repository       = var.nginx_helm_repository
  chart            = var.nginx_helm_chart
  version          = var.nginx_helm_version
  namespace        = var.nginx_helm_namespace
  create_namespace = var.nginx_helm_create_namespace

  values = [
    # values.yaml file contents copied from official repo at https://github.com/kubernetes/ingress-nginx/releases/tag/helm-chart-4.0.1
    file("${path.module}/helm/nginx-ingress-values.yaml")
  ]

  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
}