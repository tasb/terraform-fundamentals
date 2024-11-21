variable "repo" {
  description = "The name of the repository"
  type = object({
    name        = string
    description = string
    visibility  = optional(string, "private")
  })
}

variable "priority_labels" {
  description = "The number of priority labels to create"
  type        = number
  default     = 3
  validation {
    condition     = var.priority_labels >= 0 && var.priority_labels <= 5
    error_message = "The number of priority labels must be between 1 and 5. If set to 0, no priority labels will be created."
  }
}

variable "issues" {
  description = "The number of issues to create"
  type = list(object({
    title = string
    body  = string
  }))
  default = []
}
