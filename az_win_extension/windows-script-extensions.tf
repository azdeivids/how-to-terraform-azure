resource "random_password" "administrator_password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "azurerm_virtual_machine_extension" "web_vm_setup_01" {
  name                 = "WGWEB1-Server-Setup"
  virtual_machine_id   = module.main.web01_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<SETTINGS
  {    
    "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.webConfig.rendered)}')) | Out-File -filepath deploy-cloudshop.ps1\" && powershell -ExecutionPolicy Unrestricted -File deploy-cloudshop.ps1 -cloudshopurl ${data.template_file.webConfig.vars.cloudshopurl}" 
  }
  
  SETTINGS
}

resource "azurerm_virtual_machine_extension" "web_vm_setup_02" {
  name                 = "WGWEB2-Server-Setup"
  virtual_machine_id   = module.main.web02_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<SETTINGS
  {    
    "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.webConfig.rendered)}')) | Out-File -filepath deploy-cloudshop.ps1\" && powershell -ExecutionPolicy Unrestricted -File deploy-cloudshop.ps1 -cloudshopurl ${data.template_file.webConfig.vars.cloudshopurl}" 
  }
  
  SETTINGS
}

data "template_file" "webConfig" {
    template = "${file("${path.module}/scripts/deploy-cloudshop.ps1")}"
    vars = {
        user         = var.administrator_login
        password     = random_password.administrator_password.result
        cloudshopurl = var.CloudShopDownloadUrl
  }
}

resource "azurerm_virtual_machine_extension" "sql_db_setup" {
  name                 = "SQL-Server-Setup"
  virtual_machine_id   = module.main.sql01_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<SETTINGS
  {    
    "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.sqlConfig.rendered)}')) | Out-File -filepath deploy-cloudshop-db.ps1\" && powershell -ExecutionPolicy Unrestricted -File deploy-cloudshop-db.ps1 -user ${data.template_file.sqlConfig.vars.user} -password ${data.template_file.sqlConfig.vars.password} -dbsource ${data.template_file.sqlConfig.vars.dbsource} -sqlConfigUrl ${data.template_file.sqlConfig.vars.sqlConfigUrl}" 
  }
  
  SETTINGS
}

data "template_file" "sqlConfig" {
    template = "${file("${path.module}/scripts/deploy-cloudshop-db.ps1")}"
    vars = {
        user         = var.administrator_login
        password     = random_password.administrator_password.result
        dbsource     = var.CloudShopDBDownloadUrl
        sqlConfigUrl = var.SQLConfigScriptUrl
  }
}