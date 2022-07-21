variable "region" {
  type        = string
  description = "region where the client need to be created"
  default     = "us-west-2"
}

variable "az" {
  default     = "us-west-2a"
  description = "availability zone within the region"
}

variable "node_count" {
  default     = 1
  description = "number of nodes to be created"
}
variable "ami" {
  default     = "ami-0821373572f69d497"
  description = "ami. The default is centos, change if you need to use ubuntu"
}
variable "instance_type" {
  default = "c5.large"
}
variable "pem_file_name" {
  #  default     = "abcd"
  description = "specify the pem file name without the .pem extension"
}
variable "pem_file_path" {
  #  default     = "/path/to/file/abcd.pem"
  description = "Absolute path of the pem file"
}

variable "security_group" {
  #  default     = ["your_security_group"]
  description = "specify the security group to be used"
}
variable "subnet_id" {
  #  default     = "your_subnet_id"
  description = "subnet id"
}
variable "user" {
  #  default     = "your_username"
  description = "add username so that resources are tagged correctly"
}


