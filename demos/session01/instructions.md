# Demo - Your first Terraform commands

## Table of Contents

- [Step 01: Check Terraform Code](#step-01-check-terraform-code)
- [Step 02: Terraform init](#step-02-terraform-init)
- [Step 03: Terraform plan](#step-03-terraform-plan)
- [Step 04: Terraform apply](#step-04-terraform-apply)
- [Step 05: Run terraform plan again](#step-05-run-terraform-plan-again)
- [Step 06: Run terraform apply again](#step-06-run-terraform-apply-again)
- [Step 07: Authentication](#step-07-authentication)
- [Step 08: Show idempotence](#step-08-show-idempotence)

## Step 01: Check Terraform Code

- Open `main.tf` file
- Show github provider
- Show resource to create a repo

## Step 02: Terraform init

- Run `terraform init` command
- Check command output
- Show `.terraform.lock.hcl` file and `.terraform` folder

## Step 03: Terraform plan

- Run `terraform plan` command
- Check command output

## Step 04: Terraform apply

- Run `terraform apply` command
- Check that the output is the same as the plan
- Show that the command ask you to answer if you want to complete the command

## Step 05: Run terraform plan again

- Run `terraform plan -out myplan` command
- Check `myplan` file

## Step 06: Run terraform apply again

- Run `terraform apply myplan` command

## Step 07: Authentication

- Explain that in this case we are using the integration with GitHub CLI
- Run `gh auth login` to update the token

## Step 08: Show idempotence

- Run `terraform apply myplan` command again
- Check that you don't have any change to be applied
