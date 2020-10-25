#! /bin/bash

sudo yum update
sudo yum install git java docker -y
sudo service docker start
sudo usermod -aG docker ec2-user
sudo systemctl enable docker
sudo chkconfig docker on
sudo docker run -d -p 9090:9090 --name prometheus prom/prometheus

