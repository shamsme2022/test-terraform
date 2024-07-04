variable "cloud_front_distribution_name" {
  type        = string
  description = ""
  default     = ""
}

variable "s3_primary_origin_id" {
  type        = string
  description = ""
  default     = ""
}

variable "s3_primary_domain_name" {
  type        = string
  description = ""
  default     = ""
}

variable "s3_failover_origin_id" {
  type        = string
  description = ""
  default     = ""
}

variable "s3_failover_domain_name" {
  type        = string
  description = ""
  default     = ""
}


variable "access_control_name" {
  type        = string
  description = ""
  default     = "new-access-control"
}

variable "tags" {
  type = object({
    Environment : string
    test : bool
  })
  description = ""
  default = {
    Environment : "test"
    test : true
  }
}
