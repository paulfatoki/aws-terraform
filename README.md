# aws-terraform
this is a project for showcasing deployment of software using terraform and provisioning of infrastructure in aws
# workflow process
vpc created
created internet gateway
created public and private subnets each ( public server and private server)
security group created 
route tables created (public and private)
user data created 
# commands 
# first initiated 

terraform init
# to confirm if script is ok

terraform validate

# this command below to show all resources about to be created using terraform

terraform plan 

# this command to finally approve the creation of the resources in aws 

terraform apply --auto-approve