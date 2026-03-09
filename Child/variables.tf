variable "region" {
  type    = string
  default = "us-gov-west-1"
}

variable "environment" {
  type    = string
  default = "primary"
}

variable "name_prefix" {
  type    = string
  default = "alfa"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type    = list(string)
  default = []
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["m5.large"]
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_min_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 5
}

variable "tags" {
  type    = map(string)
  default = {}
}
