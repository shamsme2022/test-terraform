variable "bucket_prefix" {
  type        = string
  description = ""
  default     = ""
}
variable "acl" {
  type        = string
  description = ""
  default     = "private"
}
variable "versioning" {
  type        = list(any)
  description = "enum of strings"
  default     = ["Enabled", "Suspended", "Disabled"]
}
variable "target_bucket" {
  type        = string
  description = ""
  default     = ""
}
variable "target_prefix" {
  type        = string
  description = ""
  default     = "log/"
}
variable "kms_master_key_id" {
  type        = string
  description = ""
  default     = "aws/s3"
}
variable "sse_algorithm" {
  type        = string
  description = ""
  default     = "aws:kms"
}
variable "tags" {
  type        = map(any)
  description = ""
  default = {
    environment = "prod"
    terraform   = "true"
  }
}
