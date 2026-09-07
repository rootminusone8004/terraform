# 🌍 Modular Multi-Cloud Infrastructure as Code

![License: MIT](https://img.shields.io/badge/License-MIT-800000.svg)
![Terraform](https://img.shields.io/badge/Terraform-v1.5+-623CE4.svg?logo=terraform&logoColor=white)
![OpenTofu](https://img.shields.io/badge/OpenTofu-v1.8+-FFDA1A.svg?logo=opentofu&logoColor=black)

## 📖 Overview

This repository provides modular, production-ready Infrastructure as Code (IaC) configurations for provisioning and managing cloud resources across **AWS** and **Vultr**.

The project is structured with reusable core modules in `modules/` and provider-specific environment root configurations in `aws/` and `vultr/`. Compatible with both [OpenTofu](https://opentofu.org/) and [Terraform](https://www.terraform.io/).

---

## 🗂️ Repository Architecture

```text
.
├── modules/                               # Reusable infrastructure modules
│   ├── aws/
│   │   ├── vpc/                           # VPC, public subnet, IGW, route tables
│   │   ├── security_group/                # Dynamic security group rules
│   │   ├── key_pair/                      # EC2 SSH key pair management
│   │   └── ec2_instance/                  # Flexible EC2 instances + SSH/env provisioning
│   └── vultr/
│       └── instance/                      # Vultr instance + SSH key + bootstrap provisioning
├── aws/                                   # AWS Root Stacks
│   ├── general/                           # General Linux dev workstation (Debian/Ubuntu/Kali/RHEL)
│   ├── kubeadm/                           # Multi-node Kubernetes cluster (control plane + workers)
│   └── windows/                           # Windows Server with RDP & WinRM configuration
├── vultr/                                 # Vultr Root Stacks
│   ├── bsd/                               # OpenBSD VPS with custom doas/SSH hardening
│   └── linux/                             # Debian Linux VPS with sudo/SSH hardening
├── .gitignore
├── LICENSE.txt
└── README.md
```

---

## 🧱 Reusable Modules

| Module | Location | Description |
|--------|----------|-------------|
| **AWS VPC** | `modules/aws/vpc` | Standardized VPC networking with public subnets, internet gateway, and route table associations. |
| **AWS Security Group** | `modules/aws/security_group` | Parameterized security group supporting dynamic ingress/egress rules and CIDR whitelisting. |
| **AWS Key Pair** | `modules/aws/key_pair` | Manages AWS key pairs using local public keys with path expansion support. |
| **AWS EC2 Instance** | `modules/aws/ec2_instance` | Configures single/multiple instances, EBS storage, tagging, and local SSH config / env generation. |
| **Vultr Instance** | `modules/vultr/instance` | Manages Vultr VPS instances, SSH key upload, template-based remote bootstrapping, and local SSH configs. |

---

## 🚀 Getting Started

### Prerequisites

- **OpenTofu v1.6+** or **Terraform v1.5+**
- Cloud credentials configured:
  - AWS: `~/.aws/credentials` or standard AWS environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`).
  - Vultr: `VULTR_API_KEY` exported in your environment.
- Local SSH keys (default: `~/.ssh/ansible.pub` and `~/.ssh/ansible`).

### Deployment Workflow

1. Navigate to the desired environment stack:
   ```bash
   cd aws/general
   # or: cd aws/kubeadm
   # or: cd aws/windows
   # or: cd vultr/linux
   # or: cd vultr/bsd
   ```

2. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. Customize `terraform.tfvars` for your needs:
   ```hcl
   ec2_type = "t2.medium"
   distro   = "debian"
   ```

4. Initialize the stack and download modules/providers:
   ```bash
   tofu init
   # or: terraform init
   ```

5. Review the execution plan:
   ```bash
   tofu plan
   # or: terraform plan
   ```

6. Apply and provision the infrastructure:
   ```bash
   tofu apply
   # or: terraform apply
   ```

7. Tear down resources when no longer needed:
   ```bash
   tofu destroy
   # or: terraform destroy
   ```

---

## ⚙️ Environment Configurations

### 1. AWS General Workstation (`aws/general`)
Provisions a dedicated development node in an isolated VPC.
- **Distro Options:** `debian`, `ubuntu`, `kali`, `redhat`.
- **Features:** Auto-registers in `~/.ssh/config` with X11 forwarding support, generates local `env` file.

### 2. AWS Kubernetes Cluster (`aws/kubeadm`)
Provisions a multi-node Kubernetes cluster.
- **Components:** 1 control-plane node (40GB encrypted disk) + `N` worker nodes (30GB encrypted disk).
- **Features:** Automatically outputs all node IPs and populates local `env` with private and public addresses for cluster automation.

### 3. AWS Windows Server (`aws/windows`)
Provisions a Windows Server instance configured for remote management.
- **Features:** Automated PowerShell user-data for WinRM HTTP (5985) & firewall configuration, RDP (3389) ingress whitelisting based on your current public IP.

### 4. Vultr BSD Server (`vultr/bsd`)
Provisions an OpenBSD server on Vultr with automated hardening.
- **Features:** `doas` configuration, SSH key injection, password authentication disabled, automated `~/.ssh/config` generation.

### 5. Vultr Linux Server (`vultr/linux`)
Provisions a Debian Linux server on Vultr with automated hardening.
- **Features:** Non-root sudo user setup, SSH hardening, and automated local environment integration.

---

## 🛡️ Network Security & Ingress/Egress Hardening

Previously, security groups allowed unrestricted inbound access (`0.0.0.0/0` on all ports). This has been upgraded to industry-standard **least-privilege ingress** while maintaining complete functionality:

1. **Auto-Detected Admin Access**:
   - Workstation public IPs are automatically detected via `https://checkip.amazonaws.com` during `plan` and `apply`.
   - Ingress for management services (SSH on port 22, RDP on port 3389, WinRM on ports 5985/5986, and Kubernetes API on port 6443) is **strictly restricted to your IP**.
   - Can be overridden anytime via `allowed_admin_cidr` or `allowed_ssh_cidr` in `terraform.tfvars`.
2. **Intra-Cluster Kubernetes Security**:
   - Kubernetes cluster nodes communicate freely with each other via security group self-reference (`self = true`) and subnet CIDR.
   - Critical cluster services (etcd `2379-2380`, Kubelet `10250`, controller `10257`, scheduler `10259`) are **never exposed to the public internet**.
   - NodePort ranges (`30000-32767`) are restricted to authorized admin IPs by default and can be configured independently via `allowed_nodeport_cidr`.
3. **Outbound Internet Access (Egress `0.0.0.0/0`)**:
   - Full outbound internet access is preserved across all instances to allow package managers (`apt`, `dnf`), container image registries, PowerShell gallery, and Windows updates to function normally.

---

## 📚 Best Practices Followed

- **Strict Modular Design:** No repeated networking or instance boilerplate; shared logic lives in `modules/`.
- **Least-Privilege Security:** Ingress is strictly locked down to authorized admin IPs and internal VPC/SG traffic.
- **Consistent File Standards:** Every module and environment stack contains standard `main.tf`, `variables.tf`, `outputs.tf`, `providers.tf`/`versions.tf`, and `terraform.tfvars.example`.
- **Security by Default:** Sensitive variables (like passwords) are marked `sensitive = true`, state files are gitignored, and provider credentials rely on external credential stores.
- **Safe Path Resolution:** File paths utilize `pathexpand()` to handle `~` correctly across different shells and systems.

---

## ⚖️ License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE.txt) file for details.
