variable "aws_region" {
  description = "Region of deployment"
  type        = string
  default     = "us-east-1"
}

variable "aws_az" {
  description = "AZ of deployment"
  type        = string
  default     = "us-east-1a"
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}
