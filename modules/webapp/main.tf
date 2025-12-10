// Azure Web App module boilerplate
// Compliant with organizational standards

variable "environment" { type = string }
variable "region" { type = string }
variable "resource_group_name" { type = string }
variable "webapp_name" { type = string }
variable "key_vault_name" { type = string }
variable "tags" { type = map(string) }
variable "app_service_plan_sku" { type = string }
variable "runtime_stack" { type = string }
variable "private_endpoint_enabled" { type = bool }
variable "identity_type" { type = string }

resource "azurerm_resource_group" "webapp_rg" {
  name     = var.resource_group_name
  location = var.region
  tags     = var.tags
}

resource "azurerm_service_plan" "webapp_plan" {
  name                = "${var.webapp_name}-plan"
  location            = azurerm_resource_group.webapp_rg.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  sku_name            = var.app_service_plan_sku
  os_type             = "Linux"
  tags                = var.tags
}

resource "azurerm_linux_web_app" "webapp" {
  name                = var.webapp_name
  location            = azurerm_resource_group.webapp_rg.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  service_plan_id     = azurerm_service_plan.webapp_plan.id
  tags                = var.tags

  site_config {}

  identity {
    type = var.identity_type
  }

  app_settings = {
    "ENVIRONMENT" = var.environment
  }
}

output "webapp_url" {
  value = azurerm_linux_web_app.webapp.default_hostname
}
