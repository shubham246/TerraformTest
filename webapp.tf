data "azurerm_key_vault_secret" "ssl_thumbprint" {
  name         = "ssl-thumbprint"
  key_vault_id = "/subscriptions/your-subscription-id/resourceGroups/your-resource-group/providers/Microsoft.KeyVault/vaults/your-key-vault-name"
}

resource "azurerm_service_plan" "tertestplan" {
  name                = "ZNEUN01TERTEST-asp00"
  resource_group_name = local.resource_group_name
  location            = local.location
  os_type             = "Windows"
  sku_name            = "B1"
  depends_on = [
    azurerm_resource_group.testrg
  ]
}

resource "azurerm_windows_web_app" "tertestapp" {
  name                = "tertestapp"
  resource_group_name = local.resource_group_name
  location            = local.location
  service_plan_id     = azurerm_service_plan.tertestplan.id

  site_config {
    application_stack {
      current_stack="dotnet"
      dotnet_version="v6.0"
    }
  }

  depends_on = [
    azurerm_service_plan.tertestplan
  ]
}

resource "azurerm_app_service_custom_hostname_binding" "test" {
  hostname = "mytestapp.com"
  app_service_name = azurerm_windows_web_app.tertestapp.name
  resource_group_name = local.resource_group_name 
  ssl_state = "SniEnabled"
  thumbprint     = data.azurerm_key_vault_secret.ssl_thumbprint.value
  depends_on = [ azurerm_windows_web_app.tertestapp ]
}
