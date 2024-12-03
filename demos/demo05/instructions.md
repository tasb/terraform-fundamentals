# Demo 05 - Import resources

## Using aztfexport

```bash
aztfexport resource-group tbernardo-terraform-state-rg
```

## Using terraform import

```bash
terraform import azurerm_resource_group.rg "/subscriptions/49175c01-02a7-44bb-b379-2c06f4aae5b4/resourceGroups/tbernardo-terraform-state-rg"
```

- Get an error because the resource group already exists on backend in Azure
- Comment the backend in `versions.tf` file
- Cleanup the folder
- Run init and import again

```bash
terraform init

terraform import azurerm_resource_group.rg "/subscriptions/49175c01-02a7-44bb-b379-2c06f4aae5b4/resourceGroups/tbernardo-terraform-state-rg"
```

- Now run plan and check that only the other resources are created
