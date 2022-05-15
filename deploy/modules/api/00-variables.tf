variable "app_name" {
  type = string
  description = "The name for the app"
}

variable "default_region" {
  type = string
  description = "the default region for all aws services"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}
