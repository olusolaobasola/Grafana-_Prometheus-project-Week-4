
# variables.tf
variable "region" {
  default = "eu-west-2"
}
variable "availabilityZone" {
  default = "eu-west-2a"
}
variable "availabilityZone1" {
  default = "eu-west-2b"
}
variable "instanceTenancy" {
  default = "default"
}
variable "dnsSupport" {
  default = true
}
variable "dnsHostNames" {
  default = true
}
variable "vpcCIDRblock" {
  default = "10.8.0.0/16"
}
variable "subnetCIDRblock" {
  default = "10.8.1.0/24"
}
variable "subnetCIDRblock1" {
  default = "10.8.2.0/24"
}
variable "destinationCIDRblock" {
  default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
  type    = list
  default = ["0.0.0.0/0"]
}
variable "egressCIDRblock" {
  type    = list
  default = ["0.0.0.0/0"]
}
variable "mapPublicIP" {
  default = true
}
# end of variables.tf