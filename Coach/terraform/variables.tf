variable "subscription_id" {
  description = "Enter Subscription ID for provisioning resources in Azure"
}

variable "subscription_id_demo" {
  description = "Subcription ID"
}

variable "client_id" {
  description = "terraform process client_id"
}

variable "client_secret" {
  description = "terraform process client_secret"
}

variable "tenant_id" {
  description = "terraform process id tenant"
}

variable "object_id" {
  description = "terraform process object_id"   
}

variable "location" {
  type        = string
  description = "Azure Workload Location"
  default     = "westeurope"
}

variable "prefix" {
  type = string
  description = "Prefix resource name"
  default = "ctoday"
}

variable "client" {
  type = string
  description = "Client Name"
  default = "ctoday"
}

variable "rg" {
  type        = string
  description = "Resource Group Name"
  default     = "ctoday-wordpress-demo-rg"
}

variable "keyvault" {
  type        = string
  description = "Azure KeyVault name"
  default     = "ctoday-wp-akv"
}

variable "mysqlserver" {
  type        = string
  description = "Azure SQL Database for Mysql name"
  default     = "ctoday-wp-mysql-server"
}

variable "mysqldb" {
  type        = string
  description = "Azure Workload Location"
  default     = "ctoday-wp-mysql-db"
}

variable "mysql-admin-login" {
  type        = string
  description = "Login to authenticate to MySQL Server"
  default     = "demouser"

}
variable "mysql-admin-password" {
  type        = string
  description = "Password to authenticate to MySQL Server"
  default     = "demo!pass123"
}
variable "mysql-version" {
  type        = string
  description = "MySQL Server version to deploy"
  default     = "8.0"
}
variable "mysql-sku-name" {
  type        = string
  description = "MySQL SKU Name"
  default     = "GP_Gen5_2"
}
variable "mysql-storage" {
  type        = string
  description = "MySQL Storage in MB"
  default     = "5120"
}

variable "storage"{
  type      = string
  description = "Storage Account"
  default     = "ctodaystorage"
}

variable "appplan" {
  type        = string
  description = "Azure Workload Location"
  default     = "ctoday-wordpress-apl"
}

variable "appservice" {
  type        = string
  description = "Azure Workload Location"
  default     = "ctoday-wordpress-app"
}

variable "vnet" {
  type        = string
  description = "Virtual Network Name"
  default     = "vnet-ctoday-wp"
}

variable "frontdoor" {
  type    = string
  default = "ctoday-wp-afd"
}

variable "workspace" {
  type    = string
  default = "ctoday-wordpress-lawksp"
}

variable "webappcontainer01" {
  type    = string
  default = "ctoday-wp-container"
}

variable "webappsa" {
  type    = string
  default = "clubinsiderswp"
}

variable "email" {
  type = string
  default = "resabile@microsoft.com"
}