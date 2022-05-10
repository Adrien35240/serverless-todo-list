variable "app_name" {}

variable "environment" {}

variable "default_region" {}

variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}