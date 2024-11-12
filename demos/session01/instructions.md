# Demo - Your first Terraform commands

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
- Check you still need to enter `yes` to proceed

## Step 07: Run terraform apply with auto-approve

- Run `terraform apply myplan -auto-approve` command
- Now the repo is created and you can show on GitHub website

## Step 08: Authentication

- Explain that in this case we are using the integration with GitHub CLI
- Run `gh auth login` to update the token

## Step 09: Show idempotence

- Run `terraform apply myplan` command again
- Check that you don't have any change to be applied
