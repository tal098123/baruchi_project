#create variable for the resource group
variable "rg_tr_westus" {
  description = "Name of the Resource Group"
  type        = string
  default     = "rg-tr-westus"
}

#create variable for the virtual network
variable "vnet_tr_westus" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "vnet-tr-westus"
}

variable "admin_username" {
  description = "The username for the local account that will be created on the new VM."
  type        = string
}

variable "db_username" {
  description = "The username for the db."
  type        = string
}

variable "name_prefix" {
  default     = "postgresqlfs"
  description = "Prefix of the resource name."
}

variable "location" {
  default     = "westus"
  description = "Location of the resource."
}

variable "subscription_id" {
    type = string
    default = "d6c8d337-3ebc-4622-93d2-90cc522d0662"
}


variable "admin_password" {
  description = "The password for the local account that will be created on the new VM."
  type        = string
}

variable "db_password" {
  description = "The password for the db."
  type        = string
}
