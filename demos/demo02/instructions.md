# Demo - Organize your code

## Table of Contents

- [Step 01: Check Terraform Code](#step-01-check-terraform-code)
- [Step 02: Terraform init](#step-02-terraform-init)
- [Step 03: Validate the code](#step-03-validate-the-code)
- [Step 04: Terraform plan](#step-04-terraform-plan)
- [Step 05: Terraform plan changing variable value](#step-05-terraform-plan-changing-variable-value)
- [Step 06: Run terraform apply](#step-06-run-terraform-apply)
- [Step 07: Run without the plan](#step-07-run-without-the-plan)
- [Step 08: Auto approve](#step-08-auto-approve)
- [Step 09: Destroy the resource](#step-09-destroy-the-resource)
- [Step 10: Re-authenticate](#step-10-re-authenticate)
- [Step 11: Run Destroy command again](#step-11-run-destroy-command-again)

## Step 01: Check Terraform Code

- Open all files to show how code is organized
- Format the code using `terraform fmt` command

## Step 02: Terraform init

- Run `terraform init` command
- Check command output
- Show `.terraform.lock.hcl` file and `.terraform` folder

## Step 03: Validate the code

- Run `terraform validate` command
- Check command output
- Create an error on the code
- Run `terraform validate` command again
- Check the error message

## Step 04: Terraform plan

- Run `terraform plan` command
- Check command output

## Step 05: Terraform plan changing variable value

- Run `terraform plan --var=repo_name=other_terraform_repo -out myplan` command
- Print the plan file using `terraform show myplan` command

## Step 06: Run terraform apply

- Run `terraform apply myplan` command
- Check you don't need to add the variable again because is saved on the plan file

## Step 07: Run without the plan

- Run `terraform apply` command without the plan
- Now the value of the variable is the same as the default value so you will have changes to perform

## Step 08: Auto approve

- Cancel the apply command using `Ctrl+C`
- Run `terraform apply -auto-approve` command
- Now you don't need to confirm the apply command

## Step 09: Destroy the resource

- Run `terraform destroy` command
- Check that you have an auth error

## Step 10: Re-authenticate

- Run `gh auth login --scopes delete_repo` to update the token
- This will grant additional scope to allow deletion of the repository

## Step 11: Run Destroy command again

- Run `terraform destroy -auto-approve` command
- Check that the resource was destroyed
