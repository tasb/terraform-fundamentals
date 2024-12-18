# Lab 08 - Use Terraform on CI/CD

## Table of Contents

- [Learning Objectives](#learning-objectives)
- [Pre-requisites](#pre-requisites)
- [Guide](#guide)
  - [Step 01: Create a configuration drift](#step-01-create-a-configuration-drift)
  - [Step 02: Create the CI/CD workflow](#step-02-create-the-cicd-workflow)
  - [Step 03: Create GitHub Environment](#step-03-create-github-environment)
  - [Step 04: Run CI/CD workflow](#step-04-run-cicd-workflow)
- [Conclusion](#conclusion)

## Learning Objectives

- Learn how to create a CI/CD workflow using GitHub Actions
- Learn how to use Terraform on GitHub Actions
- Learn how to use GitHub Environments
- Learn how to use GitHub Approvals

## Pre-requisites

- Have finished [Lab 07](lab07.md) and having your modules ready

## Guide

### Step 01: Create a configuration drift

Navigate to Azure Portal and do the following changes on your resources:

- Delete the frontend app service
- Change the SKU of the database to another tier

These changes are only to simulate a configuration drift on your infrastructure, so you can change whatever you want.

### Step 02: Create the CI/CD workflow

On this lab, we will simulate a scenario where you run the plan on PR with the final environment but on CI/CD workflow we'll create a testing environment to be a disposable environment.

To create the CI/CD main workflow you need to open a new branch on your repository.

On your machine run the following command to create a new branch:

```bash
git checkout main
git pull
git checkout -b feature/add-ci-cd-workflow
```

Now, create a new file on `.github/workflows` folder with the name `main.yml` and add the following content:

```yaml
name: Main Workflow

on:
  push:
    branches:
      - main

env:
  PREFIX: <your_prefix>

jobs:
  plan-apply-tst:
    runs-on: ubuntu-latest
    permissions:
      id-token: write # Require write permission to Fetch an OIDC token.
      contents: read

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1
      with:
        terraform_version: 1.10.2

    - name: Azure CLI Login
      uses: azure/login@v2
      with:
        client-id: ${{ secrets.AZURE_CLIENT_ID }}
        tenant-id: ${{ secrets.AZURE_TENANT_ID }}
        subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    
    - name: Terraform Init
      run: terraform init

    - name: Terraform Plan
      run: terraform plan -var=db_password=${{ secrets.DB_PASSWORD }} -var=prefix=${{ env.PREFIX}}-tst -out ./infraTstPlan

    - name: Terraform Apply
      run: terraform apply -auto-approve ./infraTstPlan
  
  destroy-tst:
    runs-on: ubuntu-latest
    needs: plan-apply-tst
    environment: tst
    permissions:
      id-token: write # Require write permission to Fetch an OIDC token.
      contents: read

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1
      with:
        terraform_version: 1.10.2

    - name: Azure CLI Login
      uses: azure/login@v2
      with:
        client-id: ${{ secrets.AZURE_CLIENT_ID }}
        tenant-id: ${{ secrets.AZURE_TENANT_ID }}
        subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    
    - name: Terraform Init
      run: terraform init

    - name: Terraform Destroy
      run: terraform destroy -auto-approve

  plan-apply:
    runs-on: ubuntu-latest
    needs: destroy-tst
    permissions:
      id-token: write # Require write permission to Fetch an OIDC token.
      contents: read

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1
      with:
        terraform_version: 1.10.2

    - name: Azure CLI Login
      uses: azure/login@v2
      with:
        client-id: ${{ secrets.AZURE_CLIENT_ID }}
        tenant-id: ${{ secrets.AZURE_TENANT_ID }}
        subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    
    - name: Terraform Init
      run: terraform init

    - name: Terraform Plan
      run: terraform plan -var=db_password=${{ secrets.DB_PASSWORD }} -var=prefix=${{ env.PREFIX}} -out ./infraPlan

    - name: Terraform Apply
      run: terraform apply -auto-approve ./infraPlan
```

Please replace `<your_prefix>` with the prefix you are using on your resources.

Make sure that on your Terraform code you're using the Azure Backend supported by the Storage Account.

Now that you're running the terraform tool on your workflows, you need to use this backend to not lose track of your state file.

Now you can commit and push the changes to your repo:

```bash
git add .github/workflows/main.yml
git commit -m "Add CI/CD workflow"
git push -u origin feature/add-ci-cd-workflow
```

After pushing the changes, you can create a Pull Request on GitHub.

As soon as you create the Pull Request, the workflow will start running.

You should get the comment on the PR with the plan stating that you have a configuration drift and what will be changed.

### Step 03: Create GitHub Environment

On your repository, navigate to the `Settings` tab and then to `Environments` on left menu.

Click on `New environment` and create a new environment called `tst`.

Then select the option `Require reviewers` and add your user to the reviewers list.

On this way, you need to approve before the workflow can destroy `tst` environment.

The way to do this match is with the line `environment: tst` on the `destroy-tst` job.

### Step 04: Run CI/CD workflow

After checking everything on your Pull Request, you can merge it to the main branch.

As soon as you merge the Pull Request, the CI/CD workflow will start running.

Please take a look at the logs and check if everything is running as expected.

When you finish first stage, the execution will be waiting for your approval to destroy the `tst` environment.

Please approve and check all the logs to see if everything is running as expected.

Now the configuration on your code should be reflect on Azure. With thi example, you can see how Terraform can be important to keep your infrastructure aligned with your needs.

## Conclusion

In this lab, you learned how to create a CI/CD workflow using GitHub Actions to run Terraform commands.
