# 🌍 Personal Terraform Repository

![License: MIT](https://img.shields.io/badge/License-MIT-800000.svg)

## 📖 Overview

Welcome to my personal Terraform repo!
This repository contains infrastructure-as-code configurations used for provisioning and managing cloud resources across various environments. It helps me automate and standardize my setups using [Terraform](https://www.terraform.io/)

## ✅ Prerequisites

Make sure you have the following installed and configured:

- **🛠️ Terraform v1.5+** — Install Terraform
- **☁️ Cloud Provider CLI** — e.g. AWS CLI, Azure CLI, or GCP SDK
- **🔐 Valid credentials** for provisioning resources

## 🚀 Getting Started

### 1. Clone the Repository

``` bash
$ git clone 'https://github.com/rootminusone8004/terraform'
$ cd terraform/general
```

### 2. Initialize Terraform

``` bash
terraform init
```

### 3. Configure Your Variables

Update the `terraform.tfvars` or create a new one:

``` json
ec2_type = "t2.medium"
```

### 4. Review the Execution Plan

``` bash
terraform plan
```

### 5. Review the Execution Plan

``` bash
terraform apply -auto-approve
```

### 6. Tear Down the System

``` bash
terraform destroy -auto-approve
```

## 🗂️ Repository Structure

``` bash
.
├── general
│   ├── datasources.tf
│   ├── env
│   ├── linux-ssh-config.tpl
│   ├── main.tf
│   ├── providers.tf
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   ├── terraform.tfvars
│   └── variables.tf
├── kubeadm \    # same folder like general
├── LICENSE.txt
├── README.md
└── terraform.tfstate
```

## 🔧 Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| distro | Linux Distribution | string | debian | No |
| ec2_type | AWS EC2 type | string | t2.micro | No |
| volume_size | Volume size | int | 10 | No |

## 📚 Best Practices

- 🔐 Never commit secrets or credentials.
- 💾 Use remote state for collaboration and backups (e.g., S3, Terraform Cloud).
- 🧱 Structure code using modules for reusability and clarity.
- 📄 Use terraform-docs to generate documentation automatically.

## 🤝 Contributing

This is a personal project, but suggestions or ideas are welcome.
Feel free to open an issue or fork and submit a pull request.

## ⚖️ License

This project is licensed under **MIT license**. See the [LICENSE](LICENSE.txt) file for details.
