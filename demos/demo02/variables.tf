variable "repo_name" {
  description = "The name of the repository"
  type        = string
  default     = "second-terraform-repo"
}

variable "repo_description" {
  description = "The description of the repository"
  type        = string
  default     = "A repository created using Terraform"
}

variable "repo_visibility" {
  description = "The visibility of the repository"
  type        = string
  default     = "public"
}
