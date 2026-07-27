# ☁️ Terraform Azure Deployment

This repository demonstrates Infrastructure as Code (IaC) using **Terraform** to provision Azure resources. It follows Terraform best practices by organizing infrastructure into reusable configuration files and automating deployments through GitHub Actions.

The project provisions a complete Azure environment including an App Service, Storage Account, Application Insights, and Azure Key Vault with Managed Identity integration.

---

## 🚀 Features

- Infrastructure as Code using Terraform
- Azure App Service (Linux)
- Azure Resource Group
- Azure Storage Account
- Azure Application Insights
- Azure Key Vault
- Managed Identity for App Service
- Key Vault Access Policies
- GitHub Actions for automated deployments
- Remote Terraform State using Azure Storage

---

## 🏗️ Architecture

```
GitHub Actions
        │
        ▼
Terraform
        │
        ├── Resource Group
        ├── App Service Plan
        ├── Linux Web App
        ├── Storage Account
        ├── Application Insights
        └── Azure Key Vault
                 │
                 ▼
          Managed Identity
                 │
                 ▼
          Key Vault Secrets
```

---

## 📂 Repository Structure

```
.
├── .github/
│   └── workflows/          # GitHub Actions workflow
│
├── templates/
│   ├── main.tf             # Azure resources
│   ├── variables.tf        # Input variables
│   ├── outputs.tf          # Terraform outputs
│   ├── provider.tf         # Azure provider configuration
│   └── bootstrap.sh        # Backend bootstrap script
│
└── README.md
```

---

## 🛠️ Azure Resources Created

- Resource Group
- App Service Plan (Linux)
- Azure Linux Web App
- Storage Account
- Azure Application Insights
- Azure Key Vault
- Managed Identity
- Key Vault Access Policies

---

## 🔐 Security Features

- System Assigned Managed Identity
- Azure Key Vault for secret management
- Least-privilege Key Vault Access Policies
- Terraform Remote State Storage
- Tagged Azure resources for easier management

---

## ⚙️ Prerequisites

Before deploying, install:

- Terraform
- Azure CLI
- Git
- Azure Subscription

Login to Azure:

```bash
az login
```

---

## 🚀 Deployment

### Clone the repository

```bash
git clone https://github.com/Pushpendra2601/terraform-az-deployment.git

cd terraform-az-deployment/templates
```

---

### Initialize Terraform

```bash
terraform init
```

---

### Validate

```bash
terraform validate
```

---

### Preview Changes

```bash
terraform plan
```

---

### Deploy Infrastructure

```bash
terraform apply
```

---

## 📌 Terraform Resources

The project provisions the following resources:

| Resource | Purpose |
|----------|----------|
| Resource Group | Logical container for Azure resources |
| App Service Plan | Hosting plan for Linux Web App |
| Linux Web App | Web application hosting |
| Storage Account | Azure Storage |
| Application Insights | Monitoring and telemetry |
| Azure Key Vault | Secret management |
| Managed Identity | Secure Azure authentication |

---

## 📤 Outputs

Terraform outputs include useful deployment information such as:

- Resource Group Name
- App Service Name
- Storage Account Name
- Key Vault Name

---

## 🔄 CI/CD

This repository includes GitHub Actions for automating Terraform deployments.

Typical workflow:

- Checkout repository
- Authenticate with Azure
- Initialize Terraform
- Validate configuration
- Generate execution plan
- Apply infrastructure changes

---

## 🏷️ Resource Tags

All Azure resources are tagged consistently.

```hcl
project    = "terraform-learning"
week       = "week1"
managed_by = "terraform"
```

---

## 📌 Future Improvements

- Terraform Modules
- Azure SQL Database
- Azure Container Registry
- Azure Kubernetes Service (AKS)
- Azure Front Door
- Terraform Workspaces
- Environment-based deployments (Dev / QA / Prod)
- Terraform Cloud integration

---

## 📚 Learning Outcomes

Through this project I learned:

- Infrastructure as Code (IaC)
- Azure resource provisioning
- Terraform state management
- Azure Key Vault integration
- Managed Identity
- GitHub Actions CI/CD
- Secure secret management
- Terraform best practices

---

## 👨‍💻 Author

**Pushpendra Vishwakarma**

Cloud & DevOps Engineer

GitHub: https://github.com/Pushpendra2601

---
