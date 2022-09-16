# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](../Challenge%201/Challenge1.md)

## Introduction

Thank you for participating in the "SBEB" What The Hack. Before you can hack, you will need to set up some prerequisites.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete this Azure Hack

- [Windows Subsystem for Linux](../../000-HowToHack/WTH-Common-Prerequisites.md#windows-subsystem-for-linux)
  - [HomeBrew for Linux]()
  - Terraform binaire installed in the WSL Linux: 
```
brew install terraform
```
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](https://portal.azure.com)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
  - [VS Code plugin for ARM Templates](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code-plugins-for-arm-templates)
- [Docker for Windows]() or [Docker for MacOs]() or [Docker for Linux]()

## Description

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specifc to this hack.

Please do these additional setup:

## Setup and create scripts files

Those steps have to be done ONCE only (except if you destroy the Ressource Group hosting the TF State files).
Your "terraform" process will need to store the tfstate file somewhere. In an Enterprise Scale Landing Zone, this should be hosted in a blob storage in a secured central place, generally in the Adminstration subscription. 
### Setup Azure TF backend:

```
#!/bin/bash

RESOURCE_GROUP_NAME=put your RG Name for hosting the storage account for your TF state file
STORAGE_ACCOUNT_NAME=put the name of the storage account for your TF state file
CONTAINER_NAME=put the name of the storage container to host your TF state file
LOC01=francecentral
ACCOUNT=put the name of the subscription that will host the storage account for TF state file

az login

az account set -s $ACCOUNT

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOC01

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"
```

As we are achieving this workshop using Infra as Code with Terraform, to allow terraform process to connect and deploy resources, we need to provide it an Identity:
### Create an SPN to represent your Terraform application
```
# Azure AD SPN creation
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#creating-a-service-principal-using-the-azure-cli
az ad sp create-for-rbac --name tf-spn01 --role="Owner" --scopes="/subscriptions/id_of_the_demo_subscription"
```
<span style="color:red">The **"Owner"** role is given on the subscription for ease and as **it is DEMO**</span>

You need to restrict based on your security practice for Azure RBAC.
### Create Back End variables files

- Create a beconf.tfvars file in dev directory

```
resource_group_name  = "name of the resource group hosting your storage account"
storage_account_name = "name of your storage account"
container_name       = "name of the storage container you create in the previous step"
key                  = "name of the blob where the TF state will be stored"
access_key           = "access key you get from storage creation in the previous step"
```

- Create a connexion-var.tf file in dev directory

```
subscription_id = "id of the subscription hosting the tf state file"
subscription_id_demo = "id of the subscription hosting the demo"

client_id="client id of the AAD SPN Created to represent your terraform process"
client_secret="client secret of the AAD SPN Created to represent your terraform process"
tenant_id="AAD tenant id that host the SPN representing your terraform process"
```

## Terraform command

```
## Terraform initialise backend
terraform init -backend-config dev/beconf.tfvars -reconfigure
## terraform init with upgrade module version
# terraform init -upgrade -backend-config dev/beconf.tfvars -reconfigure
## terraform check files
# terraform fmt -check -recursive
## terraform plan deploiement
terraform plan -var-file dev/connexion-var.tf
## terraform effective deploiement
terraform apply -var-file dev/connexion-var.tf -auto-approve
## terraform delete deploiement
## WARNING: every AZURE resource will be deleted ....
# terraform apply -var-file dev/connexion-var.tf -destroy -auto-approve
```

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that docker is running
- Verigy that you can initiate the TF file

## Learning Resources

**\*Note:** Use descriptive text for each link instead of just URLs.\*


- [What is a Thingamajig?](https://www.bing.com/search?q=what+is+a+thingamajig)
- [10 Tips for Never Forgetting Your Thingamajic](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
- [IoT & Thingamajigs: Together Forever](https://www.youtube.com/watch?v=yPYZpwSpKmA)

