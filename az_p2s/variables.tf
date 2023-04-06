variable "location" {
  description = "Location where all the resources will be stored."
  type        = string
}

variable "main_kv_name" {
  description = "Key vault where the ssh public key is being stored."
  type = string
}

variable "main_kv_rg_name" {
  description = "SSH key vault resource group."
  type = string
}

variable "ssh_pub_key_name" {
  description = "Key vault secret name name for the public key secret value."
}