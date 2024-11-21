
locals {
  has_issues         = true
  has_projects       = false
  has_wiki           = true
  has_discussions    = false
  has_downloads      = false
  auto_init          = true
  gitignore_template = "Terraform"
}

resource "random_shuffle" "issue_label_color" {
  input        = ["81113C", "85ABF6", "7AE558", "B258E4", "F55428", "3B52B1"]
  result_count = 1
}

resource "random_integer" "priority_label" {
  min = 0
  max = (var.priority_labels)-1
}

resource "github_repository" "new_repo" {

  name        = var.repo.name
  description = var.repo.description
  visibility  = var.repo.visibility

  has_issues         = local.has_issues
  has_projects       = local.has_projects
  has_wiki           = local.has_wiki
  has_discussions    = local.has_discussions
  has_downloads      = local.has_downloads
  auto_init          = local.auto_init
  gitignore_template = local.gitignore_template
}

resource "github_issue_label" "priority_labels" {
  count = var.priority_labels

  name        = "priority-${count.index + 1}"
  color       = random_shuffle.issue_label_color.result[0]
  description = "Priority ${count.index + 1}"
  repository  = github_repository.new_repo.name
}

resource "github_issue" "issues" {
  for_each = { for issue in var.issues : issue.title => issue }

  title      = each.value.title
  body       = each.value.body
  labels     = [github_issue_label.priority_labels[random_integer.priority_label.result].name]
  repository = github_repository.new_repo.name
}
