NTI Project Terraform
Private AWS Web Architecture with Terraform & Load Balancing
📌 Project Overview

This project demonstrates how to build a secure, highly available AWS web architecture using Terraform as Infrastructure as Code (IaC).

The infrastructure is deployed in AWS (eu-west-3 – Paris) and follows best practices:

Private EC2 instances (no public IPs)

Application Load Balancer (ALB)

Multi-AZ deployment

Remote Terraform state using S3

State locking with DynamoDB

Automated Apache installation using user data

This project was developed using WSL Ubuntu and AWS Academy.

🏗️ Architecture Overview

High-level design:

One VPC (10.0.0.0/16)

2 Public Subnets (ALB + NAT Gateway)

2 Private Subnets (EC2 instances)

Internet Gateway for public access

NAT Gateway for outbound internet from private subnets

Application Load Balancer (HTTP – Port 80)

Apache Web Servers running on Amazon Linux 2023

Terraform backend stored in S3 with DynamoDB locking

📂 Project Structure
nti_project_terraform/
├── backend.tf          # Terraform remote backend (S3 + DynamoDB)
├── provider.tf         # AWS provider configuration
├── main.tf             # All infrastructure resources
├── variables.tf        # Input variables
├── terraform.tfvars    # Variable values
├── outputs.tf          # Terraform outputs
├── setup_apache.sh     # Apache installation & HTML setup (user_data)
├── html.html           # Optional static HTML file
└── README.md           # Project documentation

⚙️ Technologies Used

Terraform

AWS (Academy Account)

Amazon VPC

EC2 (Amazon Linux 2023)

Application Load Balancer

S3 (Terraform state storage)

DynamoDB (state locking)

Apache HTTP Server

WSL Ubuntu

🔐 Terraform Remote Backend

Terraform state is securely stored using:

S3 Bucket – Remote state storage

DynamoDB Table – State locking to prevent conflicts

This setup ensures:

Safe collaboration

Versioned state

Protection from accidental overwrites

🚀 Deployment Steps
1️⃣ Prerequisites

AWS CLI configured

Terraform installed

S3 bucket and DynamoDB table already created

AWS credentials exported (AWS Academy session)

2️⃣ Initialize Terraform
terraform init -reconfigure

3️⃣ Validate Configuration
terraform validate

4️⃣ Review Execution Plan
terraform plan

5️⃣ Deploy Infrastructure
terraform apply

6️⃣ Access the Application

After deployment, get the Load Balancer DNS:

terraform output alb_dns_name


Open the URL in a browser to view the NTI DevSecOps Apache Web Page.
Refreshing the page will show load balancing between servers.

🧪 User Data Automation

EC2 instances automatically install and configure Apache using:

setup_apache.sh


This script:

Updates the system

Installs Apache

Starts and enables the service

Deploys a custom NTI HTML page

🛡️ Security Best Practices Applied

EC2 instances in private subnets

No public IPs on EC2

Only ALB exposed to the internet

Security groups restrict access

Centralized infrastructure control via Terraform

🧹 Cleanup (Destroy Resources)

To avoid unnecessary costs:

terraform destroy


⚠️ The S3 backend bucket is protected and will not be destroyed automatically.

📈 Learning Outcomes

Through this project, I learned:

How to design secure AWS architectures

Terraform project structuring

Remote state management with S3 & DynamoDB

Automating EC2 configuration with user data

Load balancing across multiple availability zones

Best practices for cloud infrastructure deployment

👨‍💻 Author

NTI DevSecOps – Egypt
Infrastructure built using Terraform & AWS
