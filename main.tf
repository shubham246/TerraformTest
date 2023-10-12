resource "azurerm_resource_group" "testrg" {
  name = local.resource_group_name
  location = local.location

}