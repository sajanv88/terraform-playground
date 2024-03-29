variable "project_id" {
  description = "The ID of the GCP project to deploy all resources in ."
  type        = string
}

variable "name" {
  type = string
}

variable "revision" {
  type = string
}

variable "regions" {
  type = list(string)
}

variable "image" {
  type = string
}

variable "revisions" {
  type = map(string)
}

variable "env_vars" {
  type    = map(string)
  default = {}
}

variable "min_scale" {
  type    = number
  default = 0
}

variable "max_scale" {
  type    = number
  default = 100
}

variable "ingress_annotation" {
  type    = string
  default = "internal"
}

variable "service_account_roles" {
  type    = list(string)
  default = []
}
