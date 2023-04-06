resource "random_string" "main" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_resource_group" "rgvm01" {
  name     = "rg-${random_string.main.result}-dev-001"
  location = var.location

  tags = {
    Env           = "Dev"
    Owner         = "deivids@deividsegle.com"
    "Cost Center" = "IT"
  }
}
