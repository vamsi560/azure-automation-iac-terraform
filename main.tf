// Terraform configuration for Azure Web App (chatpdf)
// All variables are declared in this file as required by organizational standards
// Provider block uses environment variables set by CI/CD pipeline from Azure Key Vault

terraform {
  required_version = ">= 1.6.6, < 2.0.0"
}

provider "azurerm" {
  features {}
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "region" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "chatpdf-rg-2025"
}

variable "webapp_name" {
  description = "Web App name"
  type        = string
  default     = "chatpdf-2025"
}

variable "key_vault_name" {
  description = "Key Vault name for credentials"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

variable "app_service_plan_sku" {
  description = "App Service Plan SKU"
  type        = string
}

variable "runtime_stack" {
  description = "Web App runtime stack"
  type        = string
}

variable "private_endpoint_enabled" {
  description = "Enable private endpoint"
  type        = bool
}

variable "identity_type" {
  description = "Web App identity type"
  type        = string
}

// Local module usage (must exist in repo for compliance)
module "webapp" {
  source                   = "./modules/webapp"
  environment              = var.environment
  region                   = var.region
  resource_group_name      = var.resource_group_name
  webapp_name              = var.webapp_name
  key_vault_name           = var.key_vault_name
  tags                     = var.tags
  app_service_plan_sku     = var.app_service_plan_sku
  runtime_stack            = var.runtime_stack
  private_endpoint_enabled = var.private_endpoint_enabled
  identity_type            = var.identity_type
}

output "webapp_url" {
  description = "Web App default URL"
  value       = module.webapp.webapp_url
}
