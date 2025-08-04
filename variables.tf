variable "workspace_identifier" {
  type = string
}

variable "name" {
  type        = string
  description = "Name of of the resources and the repository to connect."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resources."
  default     = null
}

variable "full_platform_identifier" {
  type        = string
  description = "Full platform identifier for the tenant."
}

variable "landing_zone_dev_identifier" {
  type        = string
  description = "Landing zone identifier for the development tenant."
}

variable "landing_zone_prod_identifier" {
  type        = string
  description = "Landing zone identifier for the production tenant."
}

variable "github_repo_definition_version_uuid" {
  type        = string
  description = "UUID of the GitHub repository building block definition version."
}

variable "github_actions_connector_definition_version_uuid" {
  type        = string
  description = "UUID of the GitHub Actions connector building block definition version."
}

variable "github_repo_definition_uuid" {
  type        = string
  description = "UUID of the GitHub repository building block definition."
}

variable "github_actions_connector_definition_uuid" {
  type        = string
  description = "UUID of the GitHub Actions connector building block definition."
}

variable "github_actions_connector_definition_version" {
  type        = number
  description = "Version of the GitHub Actions connector building block definition."
  default     = 19
}
