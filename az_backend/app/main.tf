resource "random_string" "main" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_resource_group" "rg_app" {
  name     = "rg-${local.name}-${random_string.main.result}"
  location = var.location

  tags = {
    Env           = "Dev"
    Owner         = "deivids@deividsegle.com"
    "Cost Center" = "IT"
    Created       = "4/2/23"
  }
}