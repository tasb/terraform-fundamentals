# Lab 01 - Run your first Terraform commands

## Contents

- [Pre-requisites](#pre-requisites)
- [Guide](#guide)
  - [Step 01: Install Terraform](#step-01-install-terraform)
  - [Step 02: Install GitHub CLI](#step-02-install-github-cli)
  - [Step 05: Authoring your first Terraform code](#step-05-authoring-your-first-terraform-code)
  - [Step 06: Initialize Terraform](#step-06-initialize-terraform)
  - [Step 07: Validate the code](#step-07-validate-the-code)
  - [Step 08: Plan the changes](#step-08-plan-the-changes)
  - [Step 09: Login to GitHub](#step-09-login-to-github)
  - [Step 10: Plan again the changes](#step-10-plan-again-the-changes)
  - [Step 11: Apply the changes](#step-11-apply-the-changes)
  - [Step 12: Terraform State](#step-12-terraform-state)
  - [Step 13: Destroy the resource](#step-13-destroy-the-resource)
  - [Step 14: Re-authenticate on GitHub](#step-14-re-authenticate-on-github)
  - [Step 15: Run Destroy command again](#step-15-run-destroy-command-again)

## Objectives

- Install Terraform
- Install GitHub CLI
- Author your first Terraform code
- Initialize Terraform
- Validate the code
- Plan the changes
- Apply the changes

## Pre-requisites

- Computer with a Terminal/Console
- Any code editor. Recommended: [Visual Studio Code](https://code.visualstudio.com/)
  - VS Code Terraform extension: [HashiCorp Terraform](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
- GitHub account (can be your personal account)

## Guide

### Step 01: Install Terraform

This step is different depending on your OS. Please follow the instructions on the [official Terraform documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform).

Until the end of the training, all lab guides will share instructions based on MacOS/Linux commands. If you are using Windows, please adapt the commands accordingly.

As a recommendation for Windows users, you can use [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install) to have a better experience.

To check if Terraform is installed, run the following command:

```bash
terraform --version
```

You should get an output similar to this:

```bash
Terraform v1.9.6
on darwin_arm64
```

### Step 02: Install GitHub CLI

To interact with GitHub, we will use the GitHub CLI. You can install it by following the instructions on the [official GitHub CLI documentation](https://cli.github.com/).

To check if GitHub CLI is installed, run the following command:

```bash
gh --version
```

You should get an output similar to this:

```bash
gh version 2.25.1 (2023-03-21)
https://github.com/cli/cli/releases/tag/v2.25.1
```

### Step 05: Authoring your first Terraform code

Create a new directory for your Terraform code:

```bash
mkdir terraform-labs
cd terraform-labs
```

Create a new file named `main.tf` with the following content:

```hcl
terraform {
  required_providers {
    github = {
source = "integrations/github"
version = "~> 6.0"
}
}
}

# Configure the GitHub Provider
provider "github" {}

# Create a GitHub Repository
resource "github_repository" "example_repo" {
  name = "terraform-training-labs"
  description = "A repository created to store Terraform training labs code"
  visibility = "public"

        # Optional settings
        has_issues = false
        has_wiki = false
}
```

Please copy and paste exactly the content above, even you see that the indentation is not correct.

Save the file and run the following command to format the code:

```bash
terraform fmt
```

You should see the output:

```bash
main.tf
```

Now you can check the file again to see that the code is correctly formatted.

This simple code will create a public repository on GitHub named `terraform-training-labs` on your account.

### Step 06: Initialize Terraform

To initialize Terraform, run the following command:

```bash
terraform init
```

You should see the output:

```bash
Initializing the backend...
Initializing provider plugins...
- Finding integrations/github versions matching "~> 6.0"...
- Installing integrations/github v6.3.1...
- Installed integrations/github v6.3.1 (signed by a HashiCorp partner, key ID 38027F80D7FD5FB2)
Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Navigate to the `.terraform` folder to see the downloaded plugins. Please don't change anything in this folder.

You can open the `.terraform.lock.hcl` file to see the provider version that was installed.

This code uses the [GitHub Terraform Provider](https://registry.terraform.io/providers/integrations/github/latest).

When you use a Terraform provider you can get detailed documentation about the type of resources available and how to use them. You can find the documentation for the GitHub provider [here](https://registry.terraform.io/providers/integrations/github/latest/docs).

### Step 07: Validate the code

To validate the code, run the following command:

```bash
terraform validate
```

You should see the output:

```bash
Success! The configuration is valid.
```

Edit your `main.tf` file and do the following changes:

- Delete the line `name = "terraform-training-labs"`
- Add a new line `has_popcorn = true` below line `has_wiki = false`

Now run the `terraform validate` command again:

```bash
terraform validate
```

This time you should see an error message:

```bash
╷
│ Error: Missing required argument
│ 
│   on main.tf line 14, in resource "github_repository" "example_repo":
│   14: resource "github_repository" "example_repo" {
│ 
│ The argument "name" is required, but no definition was found.
╵
╷
│ Error: Unsupported argument
│ 
│   on main.tf line 22, in resource "github_repository" "example_repo":
│   22:   has_popcorns = true
│ 
│ An argument named "has_popcorns" is not expected here.
╵
```

This error message is telling you that the `name` argument is required and that the `has_popcorns` argument is not expected.

If you're using VS Code with the Terraform extension, you can see the error messages directly in the editor.

### Step 08: Plan the changes

To see the changes that Terraform will apply, run the following command:

```bash
terraform plan
```

You should see the output:

```bash
Planning failed. Terraform encountered an error while generating this plan.

╷
│ Error: Error
│ 
│   with provider["registry.terraform.io/integrations/github"],
│   on main.tf line 11, in provider "github":
│   11: provider "github" {}
│ 
│ GET https://api.github.com/user: 401 Bad credentials []
╵
```

This happens because your provider needs to authenticate with GitHub to create the repository. We will do this in the next step using the GitHub CLI.

But you can explore other options to authenticate with GitHub in the [GitHub Provider Authentication](https://registry.terraform.io/providers/integrations/github/latest/docs#authentication).

### Step 09: Login to GitHub

To authenticate with GitHub, run the following command:

```bash
gh auth login
```

You need to answer some questions to authenticate. If you are using a personal account, you can use the default options.

Before press Enter to open the browser you should get this output:

```bash
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations? HTTPS
? Authenticate Git with your GitHub credentials? Yes
? How would you like to authenticate GitHub CLI? Login with a web browser

! First copy your one-time code: XXXX-XXXX
Press Enter to open github.com in your browser...
```

After pressing Enter, you will be redirected to the GitHub login page. Follow the instructions to authenticate. You need to enter the code that was generated in the terminal.

Finally, to test if the authentication was successful, run the following command:

```bash
gh auth status
```

You should get an output similar to this:

```bash
github.com
  ✓ Logged in to github.com as your_user
  ✓ Git operations for github.com configured to use https protocol.
  ✓ Token: gho_************************************
  ✓ Token scopes: gist, read:org, repo, workflow
```

### Step 10: Plan again the changes

Now that you are authenticated, run the `terraform plan` command again:

```bash
terraform plan
```

You should see the output:

```bash
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with
the following symbols:
  + create

Terraform will perform the following actions:

  # github_repository.example_repo will be created
  + resource "github_repository" "example_repo" {
      + allow_auto_merge            = false
      + allow_merge_commit          = true
      + allow_rebase_merge          = true
      + allow_squash_merge          = true
      + archived                    = false
      + default_branch              = (known after apply)
      + delete_branch_on_merge      = false
      + description                 = "A repository created using Terraform"
      + etag                        = (known after apply)
      + full_name                   = (known after apply)
      + git_clone_url               = (known after apply)
      + has_issues                  = true
      + has_projects                = false
      + has_wiki                    = true
      + html_url                    = (known after apply)
      + http_clone_url              = (known after apply)
      + id                          = (known after apply)
      + merge_commit_message        = "PR_TITLE"
      + merge_commit_title          = "MERGE_MESSAGE"
      + name                        = "terraform-training-labs"
      + node_id                     = (known after apply)
      + primary_language            = (known after apply)
      + private                     = (known after apply)
      + repo_id                     = (known after apply)
      + squash_merge_commit_message = "COMMIT_MESSAGES"
      + squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
      + ssh_clone_url               = (known after apply)
      + svn_url                     = (known after apply)
      + topics                      = (known after apply)
      + visibility                  = "public"
      + web_commit_signoff_required = false

      + security_and_analysis (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if
you run "terraform apply" now.
```

Let's review some important parts of the output:

- Plan summary: `Plan: 1 to add, 0 to change, 0 to destroy.` This means that Terraform will create one resource and won't change or destroy any resources.
- Resource details: The output shows all the attributes that will be created. Some of them are marked as `(known after apply)` because Terraform needs to create the resource to get this information.
- Note: Terraform recommends using the `-out` option to save the plan. This way, you can guarantee that the plan will be executed

So, let's follow the recommendation and save the plan to a file:

```bash
terraform plan -out myplan
```

Now you can check the `myplan` file to see the plan details.

```bash
cat myplan
```

Executing this command you will see a binary file with the plan details. This file is not human-readable.

To see the plan details in a human-readable format, you can use the `terraform show` command:

```bash
terraform show myplan
```

### Step 11: Apply the changes

To apply the changes and create the repository, run the following command:

```bash
terraform apply myplan
```

You should see the output:

```bash
github_repository.example_repo: Creating...
github_repository.example_repo: Creation complete after 1s [id=your_user/terraform-training-labs]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

Now you can check your GitHub account to see the new repository created.

Congratulations! You have created your first Terraform resource!

### Step 12: Terraform State

Terraform keeps track of the resources it creates in a file called `terraform.tfstate`. This file is created in the same directory where you run the Terraform commands.

You can see the content of this file by running the following command:

```bash
cat terraform.tfstate
```

This file is in JSON format and contains all the details about the resources created by Terraform.

### Step 13: Destroy the resource

To destroy the resource created, run the following command:

```bash
terraform destroy
```

You should see the output:

```bash
github_repository.example_repo: Refreshing state... [id=terraform-training-labs]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # github_repository.example_repo will be destroyed
  - resource "github_repository" "example_repo" {
      - allow_auto_merge            = false -> null
      - allow_merge_commit          = true -> null
      - allow_rebase_merge          = true -> null
      - allow_squash_merge          = true -> null
      - allow_update_branch         = false -> null
      - archived                    = false -> null
      - default_branch              = "main" -> null
      - delete_branch_on_merge      = false -> null
      - description                 = "A repository created using Terraform" -> null
      - etag                        = "W/\"7a42b9703f86ba83298c76205cfa43c1054ed1a17e4d13c20611d506b8e0aee5\"" -> null
      - full_name                   = "tasb/terraform-training-labs" -> null
      - git_clone_url               = "git://github.com/tasb/terraform-training-labs.git" -> null
      - has_discussions             = false -> null
      - has_downloads               = false -> null
      - has_issues                  = true -> null
      - has_projects                = false -> null
      - has_wiki                    = true -> null
      - html_url                    = "https://github.com/tasb/terraform-training-labs" -> null
      - http_clone_url              = "https://github.com/tasb/terraform-training-labs.git" -> null
      - id                          = "terraform-training-labs" -> null
      - is_template                 = false -> null
      - merge_commit_message        = "PR_TITLE" -> null
      - merge_commit_title          = "MERGE_MESSAGE" -> null
      - name                        = "terraform-training-labs" -> null
      - node_id                     = "R_kgDONPFk7g" -> null
      - private                     = false -> null
      - repo_id                     = 888235246 -> null
      - squash_merge_commit_message = "COMMIT_MESSAGES" -> null
      - squash_merge_commit_title   = "COMMIT_OR_PR_TITLE" -> null
      - ssh_clone_url               = "git@github.com:tasb/terraform-training-labs.git" -> null
      - svn_url                     = "https://github.com/tasb/terraform-training-labs" -> null
      - topics                      = [] -> null
      - visibility                  = "public" -> null
      - vulnerability_alerts        = true -> null
      - web_commit_signoff_required = false -> null
        # (2 unchanged attributes hidden)

      - security_and_analysis {
          - secret_scanning {
              - status = "enabled" -> null
            }
          - secret_scanning_push_protection {
              - status = "enabled" -> null
            }
        }
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value:
```

To proceed with the destruction, type `yes` and press Enter.

But you will get an error message:

```bash
github_repository.example_repo: Destroying... [id=terraform-training-labs]
╷
│ Error: DELETE https://api.github.com/repos/tasb/terraform-training-labs: 403 Must have admin rights to Repository. []
│
│
╵
```

This happened because the token used to authenticate with GitHub doesn't have the necessary permissions to delete the repository.

### Step 14: Re-authenticate on GitHub

To grant the necessary permissions to delete the repository, run the following command:

```bash
gh auth login --scopes delete_repo
```

You need to authenticate again and grant the necessary permissions. You must follow the same steps as before.

After you can validate your authentication status:

```bash
gh auth status
```

You should see the output:

```bash
github.com
  ✓ Logged in to github.com as your_user
  ✓ Git operations for github.com configured to use https protocol.
  ✓ Token: gho_************************************
  ✓ Token scopes: delete_repo, gist, read:org, repo, workflow
```

We have done this step for you to understand that Terraform is always dependent from authentication and authorization processes from the provider you are using.

### Step 15: Run Destroy command again

Now that you have the necessary permissions, run the `terraform destroy` command again:

```bash
terraform destroy
```

You need to confirm the destruction by typing `yes` and pressing Enter.

You should see the output:

```bash
github_repository.example_repo: Destroying... [id=terraform-training-labs]
github_repository.example_repo: Destruction complete after 1s
```

Now you can check your GitHub account to see that the repository was deleted.

Let's check the content of the `terraform.tfstate` file again:

```bash
cat terraform.tfstate
```

The content of this file is now like this:

```json
{
  "version": 4,
  "terraform_version": "1.9.6",
  "serial": 3,
  "lineage": "14902e54-9086-9508-6aa6-b23b06e12e81",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```

Congratulations! You have completed your first Terraform lab!
