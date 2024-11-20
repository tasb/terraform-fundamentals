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

# Create a GitHub Repository
resource "github_repository" "example_repo" {
  name        = "my-terraform-repo-20241114"
  description = "A repository created using Terraform"
  visibility  = "public" # Use "private" for a private repository

  # Optional settings
  has_issues   = true
  has_wiki     = true
  has_projects = false
}
