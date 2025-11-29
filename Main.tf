module "rg" { # pehle bhi yahi tha
  source = "../prod/modules/azurerm_resource_group"
  rgs    = var.rgs
}



module "network" {
  source   = "../prod/modules/azurerm_networking"
  networks = var.networks
}

module "public_ip" {
  source     = "../prod/modules/azurerm_public_ip"
  public_ips = var.public_ips
}

module "key_vault" {
  source     = "../prod/modules/azurerm_key_vault"
  key_vaults = var.key_vaults
}

module "sql_server" {
  depends_on      = [module.rg]
  source          = "../prod/modules/azurerm_sql_server"
  sql_server_name = "sql-dev-todoapp-786"
  rg_name         = "rg-pilu-dev-todoapp-01"

  location       = "centralindia"
  admin_username = "devopsadmin"
  admin_password = "P@ssw01rd@123"
  tags           = {}
}

module "sql_db" {
  depends_on  = [module.sql_server]
  source      = "../prod/modules/azurerm_sql_database"
  sql_db_name = "sqldb-dev-todoapp"
  server_id   = module.sql_server.server_id
  max_size_gb = "2"
  tags        = {}
}