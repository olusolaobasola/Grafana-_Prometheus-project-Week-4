provider "aws" {
  version = "~>2.0"
  profile = "default"
  region  = var.region
}

# create the VPC
resource "aws_vpc" "My_VPC" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy
  enable_dns_support   = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = "My VPC"
  }
} # end resource

# create the Subnet grafana
resource "aws_subnet" "My_VPC_Subnet_Grafana" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.subnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone
  tags = {
    Name = "My VPC Subnet Grafana"
  }
} # end resource

# create the Subnet prometheus
resource "aws_subnet" "My_VPC_Subnet_Prometheus" {
  vpc_id            = aws_vpc.My_VPC.id
  cidr_block        = var.subnetCIDRblock1
  availability_zone = var.availabilityZone1
  tags = {
    Name = "My VPC Subnet prometheus"
  }
} # end resource

# Create the Internet Gateway
resource "aws_internet_gateway" "My_VPC_GW" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = "My VPC Internet Gateway"
  }
} # end resource

# Create the Route Table
resource "aws_route_table" "My_VPC_route_table" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = "My VPC Route Table"
  }
} # end resource

# Create the Internet Access
resource "aws_route" "My_VPC_internet_access" {
  route_table_id         = aws_route_table.My_VPC_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.My_VPC_GW.id
}
# end resource

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "My_VPC_association" {
  subnet_id      = aws_subnet.My_VPC_Subnet_Grafana.id
  route_table_id = aws_route_table.My_VPC_route_table.id
}
# end resource

# Create the Security Group Grafana
resource "aws_security_group" "My_VPC_SecurityGroup_Grafana" {
  vpc_id      = aws_vpc.My_VPC.id
  name        = "My VPC SecurityGroup Grafana"
  description = "My VPC SecurityGroup Grafana"
  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  # allow ingress of port 3000
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
  }
  # allow egress of all ports 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "My VPC SecurityGroup Grafana"
    Description = "My VPC SecurityGroup Grafana"
  }
} # end resource

# Create the Security Group Prometheus
resource "aws_security_group" "My_VPC_SecurityGroup_Prometheus" {
  vpc_id      = aws_vpc.My_VPC.id
  name        = "My VPC SecurityGroup Prometheus"
  description = "My VPC SecurityGroup Prometheus"

  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # allow ingress of port 9090
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
  }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "My VPC SecurityGroup Prometheus"
    Description = "My VPC SecurityGroup Prometheus"
  }
} # end resource

# Create EC2 instance grafana
resource "aws_instance" "grafana_node" {
  ami                    = "ami-0e78a6efff1badf0c"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.My_VPC_Subnet_Grafana.id
  key_name               = "DAY 2 HOMEWORK"
  vpc_security_group_ids = [aws_security_group.My_VPC_SecurityGroup_Grafana.id]

  tags = {
    Name        = "grafana node"
    provisioner = "terraform"
  }
}

output "ip" {
  value       = "aws_instance.grafana_node.public_ip"
  description = "The URL of the grafana instance."
}

# Create EC2 instance prometheus
resource "aws_instance" "prometheus_node" {
  ami                    = "ami-07c29df3d58ab80a0"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.My_VPC_Subnet_Prometheus.id
  key_name               = "DAY 2 HOMEWORK"
  vpc_security_group_ids = [aws_security_group.My_VPC_SecurityGroup_Prometheus.id]

  tags = {
    Name        = "prometheus node"
    provisioner = "terraform"
  }
}

