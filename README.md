# Terraform Azure Deployment — Week 1
 
> 10 months in as a DevOps Engineer. Been deploying Azure for clients using PowerShell & ARM templates.  
> This repo is Week 1 of learning **Terraform + GitHub Actions** from scratch — documented publicly, bugs and all.
 
---
 
## Resources Deployed
 
| Resource | Name (default) | Details |
|---|---|---|
| Resource Group | `terraform-devops-rg` | Region: `eastus2` |
| App Service Plan | `terraform-devops-plan` | Linux, SKU: F1 (free tier) |
| Linux Web App | `terraform-devops-app-12345` | System Assigned Managed Identity enabled |
| Key Vault | `terraformdevopskv123` | Standard SKU, purge protection enabled |
| Application Insights | `terraform-devops-insights` | Type: web |
| Storage Account | `terraformdevopsstore123` | Standard LRS |
 
All resources are tagged with:
```hcl
project    = "terraform-learning"
week       = "week1"
managed_by = "terraform"
```
 
---
 
## Repo Structure
 
```
TERRAFORM-AZ-DEPLOYMENT/
├── .github/
│   └── workflows/
│       └── terraform.yml       # GitHub Actions CI/CD pipeline
└── templates/
    ├── main.tf                  # All Azure resources
    ├── variables.tf             # Typed variables with descriptions
    ├── outputs.tf               # Output values post-deploy
    ├── provider.tf              # AzureRM provider + remote state backend
    └── bootstrap.sh             # One-time remote state backend setup
```
 
---
 
## How the Pipeline Works
 
Trigger branch: `development`
 
```
Push to development
        │
        ▼
  Azure Login
  (AZURE_CREDENTIALS secret)
        │
        ▼
  Extract ARM_CLIENT_ID, ARM_CLIENT_SECRET,
  ARM_SUBSCRIPTION_ID, ARM_TENANT_ID from secret
        │
        ▼
  Bootstrap check
  az group exists --name tfstate-rg
  └── false → runs bootstrap.sh (creates tfstate-rg + storage + container)
  └── true  → skips, backend already ready
        │
        ▼
  terraform init
        │
        ▼
  terraform fmt -check
        │
        ▼
  terraform validate
        │
        ▼
  terraform plan -out=tfplan
        │
        ▼
  terraform apply -auto-approve tfplan
  (only on push, skipped on Pull Requests)
```
 
| Event | Runs |
|---|---|
| Push to `development` | Full pipeline — plan + apply |
| Pull Request to `development` | Plan only — no apply |
 
---
 
## Remote State Design
 
Terraform state is stored in a **dedicated, separate resource group** (`tfstate-rg`) that is intentionally **not managed by Terraform itself**.
 
This avoids the chicken-and-egg problem: Terraform needs a storage backend to run, but you can't use Terraform to create that backend.
 
`bootstrap.sh` solves this by:
1. Deriving a unique storage account name from your subscription ID
2. Creating `tfstate-rg`, the storage account, and `tfstate` container via Azure CLI
3. Auto-updating `provider.tf` with the correct storage account name via `sed`
4. Being fully idempotent — safe to run multiple times
 
State file location in blob:
```
container : tfstate
key       : week1.terraform.tfstate
```
 
---
 
## Key Vault — Access Policies
 
Two access policies are created explicitly:
 
**App Service → Key Vault** (via Managed Identity)
```hcl
secret_permissions = ["Get", "List"]
```
 
**Deploying Service Principal → Key Vault**
```hcl
secret_permissions = ["Get", "List", "Set", "Delete", "Purge"]
```
 
Without these, the Key Vault exists but nothing can read from or write to it.
 
---
 
## Setup
 
### 1. Create a Service Principal
 
```bash
az ad sp create-for-rbac \
  --name "terraform-github-actions" \
  --role Contributor \
  --scopes /subscriptions/<your-subscription-id> \
  --sdk-auth
```
 
### 2. Add GitHub Secret
 
Go to **GitHub → Settings → Secrets → Actions → New repository secret**
 
| Secret Name | Value |
|---|---|
| `AZURE_CREDENTIALS` | Full JSON output from the command above |
 
The JSON looks like:
```json
{
  "clientId": "...",
  "clientSecret": "...",
  "subscriptionId": "...",
  "tenantId": "..."
}
```
 
### 3. Push to `development` branch
 
The pipeline handles everything from here — bootstrap, init, plan, apply. No manual steps.
 
---
 
## Variables
 
| Variable | Type | Default | Description |
|---|---|---|---|
| `resource_group_name` | string | `terraform-devops-rg` | Name of the Azure Resource Group |
| `location` | string | `eastus2` | Azure region for all resources |
| `app_service_plan_name` | string | `terraform-devops-plan` | Name of the App Service Plan |
| `web_app_name` | string | `terraform-devops-app-12345` | Linux Web App name (globally unique) |
| `storage_account_name` | string | `terraformdevopsstore123` | Storage Account name (globally unique) |
| `keyvault_name` | string | `terraformdevopskv123` | Key Vault name (globally unique) |
| `appinsights_name` | string | `terraform-devops-insights` | Application Insights name |
 
---
 
## Outputs
 
After `terraform apply`, the following values are output:
 
| Output | Source |
|---|---|
| `resource_group_name` | `azurerm_resource_group.rg.name` |
| `web_app_url` | `azurerm_linux_web_app.app.default_hostname` |
| `storage_account_name` | `azurerm_storage_account.storage.name` |
| `key_vault_name` | `azurerm_key_vault.kv.name` |
| `application_insights_name` | `azurerm_application_insights.insights.name` |
 
---
 
## Bug I Hit — And The Fix
 
Bootstrap was checking global Azure name availability instead of whether my own resource group existed:
 
```bash
# ❌ Wrong — "tfstatestore" was taken by someone else globally
# Returned false → bootstrap silently skipped → terraform init 404'd
az storage account check-name --name tfstatestore
 
# ✅ Correct — checks if YOUR resource group exists in your subscription
az group exists --name tfstate-rg
```
 