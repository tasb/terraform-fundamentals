
output "repo_url" {
  description = "The URL of the repository"
  value       = github_repository.new_repo.html_url
}

output "http_clone_url" {
  description = "The HTTP clone URL of the repository"
  value       = github_repository.new_repo.http_clone_url
  sensitive   = true
}

output "issue_labels_url" {
  description = "The URL of the issue labels"
  value       = github_issue_label.priority_labels[*].url
}

output "issue_ids" {
  description = "The IDs of the issues"
  value       = [for issue in github_issue.issues : issue.id]
}
