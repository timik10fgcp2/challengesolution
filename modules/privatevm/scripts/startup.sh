# install apache web server on private vm (means vm on sub3)
# add sudo yum update -y in production setting 
# firewall rules for Red Hat - potentially review how and why change them in a better way
# replacing the apache default page with hello world (otherwise http health check in load balancer would fail)
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent && sudo firewall-cmd --zone=public --permanent --add-service=http && sudo firewall-cmd --reload && sudo yum install httpd -y && sudo systemctl enable httpd.service --now && echo '<!doctype html><html><body><h1>Hello World!</h1></body></html>' | sudo tee /var/www/html/index.html



