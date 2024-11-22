variable "region"{
    default = "us-east-1"
}
variable "cluster_name" {
  default = "eks-demo"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "desired_capacity" {
  default = 2
}
variable "maximum_capacity" {
  default = 3
}
variable "minimum_capacity" {
  default = 1
}
variable "instance_types" {
  default = "t2.micro"
}