# Lab 05 - Import resources

## Table of Contents

- [Learning Objectives](#learning-objectives)
- [Pre-requisites](#pre-requisites)
- [Guide](#guide)
  - [Step 01: Create the Key Vault manually](#step-01-create-the-key-vault-manually)
  - [Step 02: Import the Key Vault](#step-02-import-the-key-vault)
  - [Step 03: Add a secret to the Azure Key Vault](#step-03-add-a-secret-to-the-azure-key-vault)
  - [Step 04: Add the permission to write on the Key Vault](#step-04-add-the-permission-to-write-on-the-key-vault)
- [Conclusion](#conclusion)

## Learning Objectives

- Learn how to import resources in Terraform
- Learn how to use the `azurerm_client_config` data source
- Learn how to use the `azurerm_role_assignment` resource
- Learn how to use the `depends_on` argument

## Pre-requisites

- Have finished [Lab 04](lab04.md)

## Guide

### Step 01: Create the Key Vault manually

Navigate to Azure Portal and create a new Key Vault.

The name should be `<your_prefix>-kv` and you should deploy it in the `westeurope` region.

Use your resource group from the previous labs.

Make sure you enable Azure RBAC for the Key Vault.

All the other settings can be left as default.

### Step 02: Import the Key Vault

Now open the `main.tf` file and add the following code:

```hcl
data "azurerm_client_config" "current" { }

resource "azurerm_key_vault" "kv" {
  name                        = "<your_prefix>-kv"
  location                    = "westeurope"
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  enable_rbac_authorization   = true
}
```

Observed that we are using the `data.azurerm_client_config.current.tenant_id` to get the tenant ID.

This data source retrieves the current user that is executing the Terraform code (on this case, your user).

Then you need your Key Vault Resource ID. Navigate to the Azure Portal and get the Resource ID of your Key Vault. You can find it on the group `Settings` and then `Properties`.

Now run the following command to import the Key Vault:

```bash
terraform import azurerm_key_vault.kv <your_key_vault_resource_id>
```

You should get the following output:

```bash
Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

### Step 03: Add a secret to the Azure Key Vault

Now let's add a secret to the Key Vault.

We will use the `azurerm_key_vault_secret` resource to do that and store the password of the PostgreSQL database.

Add the following code to the `main.tf` file:

```hcl
resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  value        = var.db_password
  key_vault_id = azurerm_key_vault.kv.id
}
```

You will need to have the `db_password` variable defined on the `variables.tf` file and set the value when you.

Now let's run the following command to apply the changes:

```bash
terraform plan -out kvSecretPlan

terraform apply kvSecretPlan
```

You should get a plan that says that one resource will be added and then you can apply the changes.

But when you apply the changes you will get an error because your user doesn't have the permission to write on the Key Vault.

Since you enabled Azure RBAC you need to give your user the permission to write on the Key Vault.

### Step 04: Add the permission to write on the Key Vault

Edit your `main.tf` file and add the following code:

```hcl
resource "azurerm_role_assignment" "example" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}
```

This resource will assign the needed role to your user. Using this `azurerm_client_config` data source, your code can get the object ID of any user that runs the code.

But you need to do another change on the secret resource. You need to add a dependency on the role assignment.

This is needed because you don't have any implicit dependency between them but you need the role assignment to be created before the secret.

Your `azurerm_key_vault_secret` resource should look like this:

```hcl
resource "azurerm_key_vault_secret" "kv_secret" {
  name         = "db-password"
  value        = var.db_password
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [azurerm_role_assignment.example]
}
```

Now you can run the following command to apply the changes:

```bash
terraform plan -out kvSecretPlan

terraform apply kvSecretPlan
```

## Conclusion

In this lab, you have learned how to import resources in Terraform.
