# Global variables
variable "project" {
  description = "The name of the project"
  type        = string
  default     = "example-university"
}

variable "env" {
  description = "The environment (prod, dev, staging, etc.)"
  type        = string
  default     = "prod"
}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "azs" {
  description = "The availability zones to deploy resources in"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# VPC variables
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subs" {
  description = "The CIDR block for the private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subs" {
  description = "The CIDR block for the public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "database_subs" {
  description = "The CIDR block for the database subnets"
  type        = list(string)
  default     = ["10.0.50.0/24", "10.0.51.0/24"]
}

# ALB variables
variable "target_ports" {
  description = "The target ports for the ALB"
  type        = list(number)
  default     = [80]
}

# Authorized CIDR blocks
variable "authorized_cidr_blocks" {
  description = "Authorized CIDR blocks"
  type        = list(string)
  default = [
    "185.13.180.223/32", // SDV ip
  ]
}

# RDS variables
variable "db_name" {
  description = "The name of the RDS database"
  type        = string
  default     = "wordpress"
}

variable "db_username" {
  description = "The username for the RDS database"
  type        = string
  default     = "admin"
}