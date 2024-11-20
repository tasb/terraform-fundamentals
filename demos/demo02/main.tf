
# Create a GitHub Repository
resource "github_repository" "example_repo" {
  name        = var.repo_name
  description = var.repo_description
  visibility  = var.repo_visibility

  # Optional settings
  has_issues   = true
  has_wiki     = true
  has_projects = false
}

