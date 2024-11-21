# Lab 02 - Organize and add variables to your Terraform code

## Prerequisites

- Have finished [Lab 01](../lab01/README.md)
- Create a new folder or remove any tfstate file from the previous lab

## Guide

### Step 01: Organize your code

Let's create separate files for resources and variables.

First, create a new file called `versions.tf` and move the terraform version definition to this file.

The content of the file should be:

```hcl
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {}
```

Then, create two new files called `variables.tf` and `outputs.tf` and keep them empty for now.

### Step 02: Add variables

Now, let's add some variables to our code.

In the `variables.tf` file, add the following content:

```hcl
variable "repo_name" {
  description = "The name of the repository to be created"
  type        = string
  default     = "terraform-repo"
  validation {
    condition     = length(var.repo_name) <= 100
    error_message = "The repository name must be less than or equal to 100 characters"
  }
}

variable "repo_description" {
  description = "The description of the repository to be created"
  type        = string
  default     = "A new repository created using Terraform"
}

variable "repo_private" {
  description = "If the repository should be private or public"
  type        = bool
  default     = false
}

variable "welcome_message" {
  description = "The welcome message to be displayed in an Issue"
  type        = string
  default     = null
}
```

### Step 03: Use variables in the code

Now, let's use the variables in the `main.tf` file.

Replace the content of the `main.tf` file with the following code:

```hcl
locals {
  has_issues         = true
  has_projects       = false
  has_wiki           = false
  has_discussions    = false
  has_downloads      = false
  auto_init          = true
  gitignore_template = "Terraform"
}

resource "github_repository" "repo" {
  name        = var.repo_name
  description = var.repo_description
  visibility  = var.repo_private ? "private" : "public"

  has_issues         = local.has_issues
  has_projects       = local.has_projects
  has_wiki           = local.has_wiki
  has_discussions    = local.has_discussions
  has_downloads      = local.has_downloads
  auto_init          = local.auto_init
  gitignore_template = local.gitignore_template
}

resource "github_issue" "welcome_issue" {
  count      = var.welcome_message != null ? 1 : 0
  repository = github_repository.repo.name
  title      = "Welcome to ${github_repository.repo.name}"
  body       = var.welcome_message
}
```

### Step 04: Add outputs

Now, let's add some outputs to our code.

Open the `outputs.tf` file and add the following content:

```hcl
output "repo_name" {
  value = github_repository.repo.name
}

output "repo_clone_url" {
  description = "The HTTP clone URL of the repository"
  value       = github_repository.repo.http_clone_url
  sensitive   = true
}

output "repo_url" {
  value = github_repository.repo.html_url
}

output "issue_id" {
  value = var.welcome_message != null ? github_issue.welcome_issue[0].issue_id : null
}
```

Take a look on the `sensitive` attribute. This attribute is used to hide the value of the output when it is printed on the console.

Then check that `issue_id` will be printed only if the `welcome_message` variable is not null and needs to index the issue array because it is a list. This is caused by the `count` attribute in the `github_issue` resource.

### Step 05: Run the code

Now, let's run the code.

First, run the `terraform init` command to initialize the working directory.

Then, run the `terraform plan -out firstPlan` command to see the changes that will be applied.

Check that you don't get any issue to be created because the `welcome_message` variable is null.

### Step 06: Change the `welcome_message` variable

Now, let's change the `welcome_message` variable.

Run the `terraform plan -var="welcome_message=Welcome to my new repo" -out secondPlan` command to see the changes that will be applied.

Now on the plan you should see that an issue will be created.

### Step 07: Use tfvars files

Now, let's create a `github.tfvars` file to store the variables values.

Create a new file called `github.tfvars` and add the following content:

```hcl
repo_name        = "terraform-repo123456789123456"
repo_description = "A new repository created using Terraform"
repo_private     = true
welcome_message  = "Welcome to my new repo!"
```

Then, run the `terraform plan -var-file=github.tfvars -out thirdPlan` command to see the changes that will be applied.

Now you should get an error because the repository name is too long.

You should see the following error message:

```shell
Planning failed. Terraform encountered an error while generating this plan.

╷
│ Error: Invalid value for variable
│ 
│   on github.tfvars line 1:
│    1: repo_name        = "terraform-repo123456789123456"
│     ├────────────────
│     │ var.repo_name is "terraform-repo123456789123456"
│ 
│ The repository name must be less than or equal to 100 characters
│ 
│ This was checked by the validation rule at variables.tf:5,3-13.
```

### Step 08: Fix the error

Usually what you should do is to change the value on the `github.tfvars` file, but for this lab, let's fix the error by changing the value directly on the command line.

This way you can check how variable set precedence works.

Run the `terraform plan -var-file=github.tfvars -var="repo_name=terraform-myrepo" -out fourthPlan` command to see the changes that will be applied.

Now you should get a plan without any errors.

### Step 09: Apply the changes

Now, let's apply the changes.

Run the `terraform apply fourthPlan` command to apply the changes.

Check that the repository was created and the issue was created as well.

After you execute the command, you should see a tfstate file created in the directory.

Please keep that file because you'll need to use it in the next lab.

Congratulations, you have finished Lab 02! Now you can use variables and outputs in your Terraform code.
