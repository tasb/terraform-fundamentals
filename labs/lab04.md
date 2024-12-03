# Lab 04 - Create Infra in Azure with Terraform

## Table of Contents

- [Goals](#goals)
- [Pre-requisites](#pre-requisites)
- [Guide](#guide)
  - [Step 01: Create the resource groups](#step-01-create-the-resource-groups)
  - [Step 02: Create the virtual network](#step-02-create-the-virtual-network)
  - [Step 03: Create the App Services](#step-03-create-the-app-services)
  - [Step 04: Create the PostgreSQL Database](#step-04-create-the-postgresql-database)
  - [Step 05: Execute Terraform code](#step-05-execute-terraform-code)
- [Conclusion](#conclusion)

## Goals

- Create resource groups in Azure
- Create a virtual network in Azure
- Create App Services in Azure
- Create a PostgreSQL Database in Azure
- Use tags in the resources

## Pre-requisites

- Have finished [Lab 03](../lab03/README.md)

## Guide

### Step 01: Create the resource groups

On this lab, you need to put what you have learned in the previous labs into practice.

You only get the main properties of the resources and you need to find the correct code to create them.

Let's start with the resource groups.

Create the following resource groups:

- `<your_prefix>-net-rg`
  - Tags:
    - `environment`: `prod`
    - `owner`: `<your_name>`
    - `type`: `network`
- `<your_prefix>-app-rg`
  - Tags:
    - `environment`: `prod`
    - `owner`: `<your_name>`
    - `type`: `application`
- `<your_prefix>-db-rg`
  - Tags:
    - `environment`: `prod`
    - `owner`: `<your_name>`
    - `type`: `database`

You need to create the resource groups in the `westeurope` region.

You should ignore manual changes that may happen at tags.

You can get more details about the resource group in the [official documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group).

### Step 02: Create the virtual network

Create a virtual network in the `<your_prefix>-net-rg` resource group.

The virtual network should have the following properties:

- Name: `<your_prefix>-vnet`
- Address space: `10.20.30.0/24`
- Subnet:
  - Name: `app`
  - Address prefix: `10.20.30.0/27`
- Subnet:
  - Name: `db`
  - Address prefix: `10.20.30.32/27`

For tagging the virtual network, use the same tags as the resource group.

You can get more details about the virtual network in the [official documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network).

### Step 03: Create the App Services

Create the following App Services in the `<your_prefix>-app-rg` resource group:

- `<your_prefix>-front-app`
  - OS: `Linux`
  - SKU:
    - Tier: `Basic`
    - Size: `B1`
  - Runtime: `.NET 8`
  - Tag:
    - `environment`: `prod`
    - `owner`: `<your_name>`
    - `type`: `application`
- `<your_prefix>-api-app`
  - OS: `Linux`
  - SKU:
    - Tier: `Basic`
    - Size: `B1`
  - Runtime: `.NET 8`
  - Tag:
    - `environment`: `prod`
    - `owner`: `<your_name>`
    - `type`: `application`

Both App Services must have a VNET Integration with the `<your_prefix>-vnet` virtual network.

To create these resources you need to have an App Service Plan where you assign the App Services.

To get more details about the App Service Plan, you can check the [official documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan).

To get more details about the App Service, you can check the [official documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service).

### Step 04: Create the PostgreSQL Database

Create a PostgreSQL Database in the `<your_prefix>-db-rg` resource group.

The database should have the following properties:

- Name: `<your_prefix>-psql`
- SKU: `B_Standard_B1ms`
- Version: `12`
- Storage:
  - Size: 32768
  - Tier: `P30`

For tagging the PostgreSQL Database, use the same tags as the resource group.

You need to set an admin username and password for the database. Be careful with the password, it should be stored in a secure way.

You can get more details about the PostgreSQL Database in the [official documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server).

### Step 05: Execute Terraform code

After creating the Terraform code, you need to execute it.

You can execute the commands during the development or only at the end.

Make sure all resources are created successfully.

## Conclusion

In this lab, you have learned how to create resources in Azure using Terraform.
