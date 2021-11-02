variable "domain" {
  description = "Route53 domain name to use for ACM certificate. Route53 zone for this domain should be created in advance"
  type        = string
  default     = ""
}

variable "alb_ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules of the ALB - use your personal IP in the form of `x.x.x.x/32` for restricted testing"
  type        = list(string)
  default     = ["10.0.0.100/32"]
}

variable "github_token" {
  description = "Github token"
  type        = string
  default     = ""
}

variable "github_owner" {
  description = "Github owner"
  type        = string
  default     = "cjsrkd3321"
}

variable "github_user" {
  description = "Github user for Atlantis to utilize when performing Github activities"
  type        = string
  default     = "atlantis"
}

variable "allowed_repo_names" {
  description = "Repositories that Atlantis will listen for events from and a webhook will be installed"
  type        = list(string)
  default     = ["atlantis-test"]
}
