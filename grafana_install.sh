#! /bin/bash
sudo yum update
sudo yum install git java docker -y
sudo service docker start
sudo usermod -aG docker ec2-user
sudo systemctl enable docker
sudo chkconfig docker on
sudo docker run -d -p 3000:3000 --name grafana grafana/grafana