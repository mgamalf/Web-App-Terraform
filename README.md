# NTI Project Terraform
## Secure AWS Infrastructure Using Terraform (AWS Academy)

---

## 📌 Project Description

This project demonstrates how to provision a **secure, highly available AWS infrastructure**
using **Terraform** as Infrastructure as Code (IaC).

The infrastructure follows AWS best practices by using:
- Private EC2 instances
- Application Load Balancer
- Multi-AZ deployment
- Remote Terraform state stored in S3
- State locking using DynamoDB

The project was built using **WSL Ubuntu**, **Terraform**, and **AWS Academy**.

---

## 🏗️ Architecture Overview

The infrastructure includes:

- One VPC with CIDR block `10.0.0.0/16`
- Two public subnets (for ALB and NAT Gateway)
- Two private subnets (for EC2 instances)
- Internet Gateway for public access
- NAT Gateway for outbound internet access from private subnets
- Application Load Balancer (HTTP on port 80)
- Two EC2 instances running Apache Web Server
- Terraform backend using S3 and DynamoDB

All EC2 instances are deployed in **private subnets** and are only accessible through the **Application Load Balancer**.

---

## 📂 Project architecture
<img width="919" height="790" alt="image" src="https://github.com/user-attachments/assets/4d538df2-f797-4752-b244-3bc8e04bee3f" />



---

## ⚙️ Technologies Used

- Terraform
- AWS (Academy Account)
- Amazon VPC
- EC2 (Amazon Linux 2023)
- Application Load Balancer (ALB)
- S3 (Terraform remote state)
- DynamoDB (State locking)
- Apache HTTP Server
- WSL Ubuntu

---

## 🔐 Terraform Backend Configuration

Terraform state is stored remotely using:
- **Amazon S3** for state storage
- **Amazon DynamoDB** for state locking

This ensures:
- Safe state management
- No concurrent state conflicts
- Better collaboration support

---

## 🚀 How to Deploy the Project

### 1️⃣ Prerequisites

- Terraform installed
- AWS CLI configured
- AWS Academy credentials active
- S3 bucket and DynamoDB table already created

---

### 2️⃣ Initialize Terraform

```bash
terraform init -reconfigure
