# Terraform module for an Azure Kubernetes Cluster

## Backend configuration
Backend Configuration:  
``resource_group_name``  = "<Resource Group Name>"  
``storage_account_name`` = "<Storage Account Name>"  
``container_name``       = "<Container Name>"  
``key``                  = "<Storage Account Key>"

## Initialize backend
``terraform init -backend-config=backend.conf``

## Terraforming
``terraform init``     - Prepare your working directory for other commands  
``terraform fmt``      - Reformat your configuration in the standard style  
``terraform validate`` - Check whether the configuration is valid  
``terraform plan``     - Show changes required by the current configuration  
``terraform apply``    - Create or update infrastructure  
``terraform destroy``  - Destroy previously-created infrastructure