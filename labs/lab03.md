# Lab 03 – Store your state in Azure

## Table of Contents

- [Goals](#goals)
- [Pre-requisites](#pre-requisites)
- [Guide](#guide)
  - [Step 01: Clone the repository](#step-01-clone-the-repository)
  - [Step 02: Create Terraform code](#step-02-create-terraform-code)
  - [Step 03: Login on Azure](#step-03-login-on-azure)
  - [Step 04: Run the Terraform code](#step-04-run-the-terraform-code)
  - [Step 05: Configure the backend](#step-05-configure-the-backend)
  - [Step 06: Run Terraform code with new backend](#step-06-run-terraform-code-with-new-backend)
- [Conclusion](#conclusion)

## Goals

- Create a new storage account in Azure
- Store the Terraform state file in the Azure Storage Account
- Configure the Terraform backend to use the Azure Storage Account
- Run the Terraform code using the new backend

## Pre-requisites

- Have finished [Lab 02](../lab02/README.md)
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## Guide

### Step 01: Clone the repository

Before cloning the repository, make sure you have the Terraform code from the previous lab.

Let's rename the repository to `terraform-training` to make it more aligned with the course.

Run the following commands:

```bash
terraform plan -var-file=github.tfvars -var="repo_name=terraform-training" -out lastPlan
terraform apply "lastPlan"
```

Please check the plan output and check what should be updated.

Since you added the HTTPS clone URL as na output, you can get it without going to GitHub website.

But that output was defined as sensitive, so you can't see it in the output directly.

To get the output value, run the following command:

```bash
terraform output repo_clone_url
```

If you get that the output still points for previous repository, you can run the following command to update the output:

```bash
terraform refresh
```

Then, run the output command again.

Now you can use the output value to clone the repository, running the following commands:

```bash
git clone <your-repo-url>
cd <your-repo-folder>
```

If you get an authentication error when cloning the repository, you can use `gh cli` to authenticate, using the following command:

```bash
gh auth login
```

And follow all the steps to authenticate.

### Step 02: Create Terraform code

Let's create the Terraform code to create a new storage account in Azure.

Create a folder called `backend` on your repo root folder.

Inside this folder, create a new file called `versions.tf` and add the following content:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.11.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "<subscription_id>"
  features {}
}
```

For Azure Provider you need to set the `subscription_id` to your Azure Subscription ID.

Login on your Azure account on the browser and get the subscription ID.

Then, create a new file called `variables.tf` and add the following content:

```hcl
variable "prefix" {
  description = "The prefix to be added to all resources. Should be your first letter of your first name and last name"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to create the storage account"
  type        = string
  default     = "terraform-state-rg"
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
  default     = "tfstate"
  validation {
    condition     = (length(var.storage_account_name) + length(var.prefix)) <= 24 && length(var.storage_account_name) >= 3
    error_message = "The storage account name must be between 3 and 24 characters in length"
  }
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "West Europe"
}

variable "container_name" {
  description = "The name of the storage container"
  type        = string
  default     = "terraform"
}
```

We add a variable called `prefix` to be used as a prefix for all resources created.

This will help to avoid conflicts with other resources in the same subscription.

Finally, create a new file called `main.tf` and add the following content:

```hcl
locals {
  resource_group_name = "${var.prefix}-${var.resource_group_name}"
  storage_account_name = "${var.prefix}${var.storage_account_name}"
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sc" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
}
```

### Step 03: Login on Azure

Before running the Terraform code, you need to authenticate on Azure.

For this lab we will use the Azure CLI to make that authentication and use your user to run the Terraform code.

First, run the following command to change the new AzCLI login mode:

```bash
az config set core.login_experience_v2=off
```

Then, navigate to the Azure portal and get the Tenant ID from your Azure account.

You can navigate to [Entra ID](https://portal.azure.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/Overview) to get your Tenant ID.

Then, run the following command to login on Azure:

```bash
az login --tenant <tenant_id>
```

Replace `<tenant_id>` with your Tenant ID.

Finally, enforce the subscription to be used on the Terraform code:

```bash
az account set --subscription <subscription_id>
```

### Step 04: Run the Terraform code

Now, let's run the Terraform code using the commands that you already know.

First, initialize the Terraform code:

```bash
terraform init
```

Then, run the plan command:

```bash
terraform plan -var="prefix=<your_prefix>" -out=plan
```

Please replace `<your_prefix>` with the first letter of your first name and last name.

Finally, apply the changes:

```bash
terraform apply "plan"
```

After you complete successfully, you should see the storage account created on your Azure account.

### Step 05: Configure the backend

Before configuring the backend, you need to upload the Terraform state file to the storage account.

Navigate to the Storage Account on the Azure portal and then to the container created.

Click on the `Upload` button and upload the `terraform.tfstate` file.

You can delete (or move to another folder) the `terraform.tfstate` and `terraform.tfstate.backup` file that exists on your folder.

Now, let's configure the backend.

Open the `versions.tf` file and add the following content inside the `terraform` block and before the `required_providers` block:

```hcl
backend "azurerm" {
  resource_group_name  = "<your_prefix>-terraform-state-rg"
  storage_account_name = "<your_prefix>tfstate"
  container_name       = "terraform"
  key                  = "terraform.tfstate"
}
```

Please replace `<your_prefix>` with the first letter of your first name and last name.

### Step 06: Run Terraform code with new backend

To use the new backend, you need to initialize the Terraform code again.

Run the following command:

```bash
terraform init
```

Then, run the plan command:

```bash
terraform plan -var="prefix=<your_prefix>" -out=plan
```

You should get an output like this:

```bash
Acquiring state lock. This may take a few moments...
azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/49175c01-02a7-44bb-b379-2c06f4aae5b4/resourceGroups/tbernardo-terraform-state-rg]
azurerm_storage_account.sa: Refreshing state... [id=/subscriptions/49175c01-02a7-44bb-b379-2c06f4aae5b4/resourceGroups/tbernardo-terraform-state-rg/providers/Microsoft.Storage/storageAccounts/tbernardotfstate]
azurerm_storage_container.sc: Refreshing state... [id=/subscriptions/49175c01-02a7-44bb-b379-2c06f4aae5b4/resourceGroups/tbernardo-terraform-state-rg/providers/Microsoft.Storage/storageAccounts/tbernardotfstate/blobServices/default/containers/terraform]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
Releasing state lock. This may take a few moments...
```

Look to this log and observe two things:

- You get a no changes output, because the state is already stored in the backend.
- The log start with `Acquiring state lock` and finish with `Releasing state lock`. This is because Terraform is locking the state file to avoid conflicts. To lock the file it uses lock and lease feature from Azure Storage Account.

## Conclusion

Congratulations! You have successfully created your first resources on Azure using Terraform and stored the state file on Azure Storage Account.
