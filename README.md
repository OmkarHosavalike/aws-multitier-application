# Multi-Tier Web Application on AWS

This repository demonstrates deploying a highly available multi-tier web application on AWS using **Terraform** and **Ansible**, with GitHub Actions workflows for automation.

---

## Architecture

- **Frontend:** Public EC2 instance running a Flask interface.
- **Backend:** Private EC2 instance hosting a Flask API that connects to RDS MySQL.
- **Database:** Amazon RDS MySQL instance.
- **S3 Bucket:** Stores backend application files, pulled by Ansible during deployment.
- **Security:** 
  - Bastion host for SSH access to private instances.
  - NAT gateway for private subnet internet access.
  - Security groups dynamically updated to allow only runner IP.
- **Automation:** 
  - Terraform provisions AWS infrastructure.
  - Ansible configures EC2 instances and deploys the application.
  - GitHub Actions automates the Terraform and Ansible workflows.

---

## Required Repository Secrets

Add the following secrets to your GitHub repository:

| Secret Name            | Purpose |
|------------------------|---------|
| `BACKEND_S3_BUCKET`    | S3 bucket for Terraform remote backend and storing app artifacts |
| `DATABASE_PASSWORD`    | MySQL database password for RDS instance |
| `OIDC_IAM_ROLE`        | AWS IAM role for GitHub OIDC connection with EC2, S3, IAM, and RDS full access |

---

## Setup Instructions

### 1. Terraform Workflow

- Provision AWS infrastructure.
- Dynamically set `my_ip_cidr` for SSH access to bastion and private instances.
- Stores backend app in S3.

```bash
# Trigger Terraform workflow in GitHub Actions
```

### 2. Ansible Workflow

- Updates security group rules to allow current runner IP.
- Installs Python, dependencies, and configures frontend and backend EC2 instances.
- Pulls backend app from S3 and sets up systemd service.

```bash
# Trigger Ansible workflow in GitHub Actions
```

---

## Testing the Application

### Add Employee (POST)

```bash
curl -X POST http://<FRONTEND_PUBLIC_IP>/employees \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "role": "Developer"}'
```
Note: Both name and role are required. If either is missing, the API returns:

```bash
{
  "error": "Missing name or role"
}
```

### List Employees (GET) 

Returns a JSON array of all employees:

```bash
curl http://<FRONTEND_PUBLIC_IP>/employees
```
