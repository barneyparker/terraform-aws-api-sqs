variable "name" {}

variable "api_id" {}

variable "resource_id" {}

variable "http_method" {}

variable "queue_name" {}

variable "authorization" {
  default     = "NONE"
}

variable "method_request_parameters" {
  type        = map
  default     = {}
}

variable "request_templates" {
  type        = map
  default     = {}
}

variable "responses" {
  type        = list
  default     = []
}