resource "azurerm_key_vault" "keyVault" {
  name                        = "testvault"
  resource_group_name         = local.resource_group_name
  location                    = local.location
  enabled_for_disk_encryption = true
  tenant_id                   = azurerm.tenant_id
  sku_name                    = "standard"
}

data "azurerm_key_vault_secret" "sql_password" {
  name         = "SqlPassword"
  key_vault_id = azurerm_key_vault.keyVault.id
}
resource "azurerm_sql_server" "data" {
  name                         = "tertestdbserver"
  resource_group_name          = local.resource_group_name
  location                     = local.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = azurerm_key_vault_secret.sql_password.value

    depends_on = [
    azurerm_resource_group.testrg
  ]
}

resource "azurerm_sql_database" "data" {
  name                = "tertestdb"
  resource_group_name = local.resource_group_name
  location            = local.location
  server_name         = azurerm_sql_server.data.name
  edition             = "GeneralPurpose"
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb         = 1
}