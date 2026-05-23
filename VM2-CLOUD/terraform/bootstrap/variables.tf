variable "muestra_region" {
  description = "The aws region availability"
  type        = string
  default     = "Default Region"
}

variable "muestra_bucket_tfstate" {
  type        = string
  description = "unique name of the S3 bucket for state"
}

variable "muestra_dynamodb" {
  type        = string
  description = "Name of the key-value-store"
}