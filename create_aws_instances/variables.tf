variable "region" {
    type = string
    description = "region where the client need to be created"
    default = "us-west-2"
}
variable "instance_count" {
    default = 1
}
variable "ami" {
    default = "ami-0821373572f69d497"
}
variable "instance_type" {
    default = "c5.large"
}
variable "pem_file_name" {
    default = "abcd"
}
variable "pem_file_path" {
    default = "/path/to/file/abcd.pem"
}
variable "security_group" {
    default = ["your_security_group"]
}
variable "subnet_id" {
    default = "your_subnet_id"
}
variable "test_user" {
    default = "your_username"
}

variable "az" {
    default = "us-west-2a"
}
