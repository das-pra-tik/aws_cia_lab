#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<html><style>body{background-color: orange;}</style><body><h1><b><i> Hello, I am host with identity $(curl -s http://169.254.169.254/latest/meta-data/local-hostname), local-ip of $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4) and located in AZ $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone) </i></b></h1></body></html>" >/var/www/html/index.html
