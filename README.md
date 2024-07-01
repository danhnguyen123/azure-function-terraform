# Azure Function by Terraform Project

Project to spin up Azure services by following this flow:

![Flow](./assets/flow.png)

- [Azure Function Terraform Project](#azure-function-terraform-project)
  - [Setup](#setup)
    - [Creating a Service Principal in the Azure Portal](#create-service-principal)
    - [Configuring the Service Principal in Terraform](#config-service-princial-in-terraform)
  - [Provisioning](#provisioning)
    - [Terraform Init](#terraform-init)
    - [Terraform Validate](#terraform-validate)
    - [Terraform Plan](#terraform-plan)
    - [Terraform Apply](#terraform-apply)



## Prerequisites

* [Azure account with subscription](https://azure.microsoft.com/en-us/free)
* [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* [Git version >= 2.37.1](https://github.com/git-guides/install-git)

## Setup

In order to run the project you'll need to preprare the credential for Terraform to provision resources in Azure
Terraform offer some of ways to get it, in this project we will authenticate Azure using a [Service Principal with a Client Secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)
 
### Creating a Service Principal in the Azure Portal

You can follow this guide to cretae Service Principal, get credentials and grant permissions - [Creating a Service Principal in the Azure Portal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#creating-a-service-principal-in-the-azure-portal)

### Configuring the Service Principal in Terraform

After you create Service Principal and get credentials, you can export these credentialsto environement variables like this:

```bash
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="12345678-0000-0000-0000-000000000000"
export ARM_TENANT_ID="10000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="20000000-0000-0000-0000-000000000000"
```

Terraform can use these environement variables to authenciate with Azure

You can read more by address this guide [Configuring the Service Principal in Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#configuring-the-service-principal-in-terraform)


## Provisioning

We will run Terraform command to create resources in Azure
 
### Terraform Init
Initialize Terrafrorm Azure Provider and Module, we will use Azure Blob Storage to act as backend which storage Terraform state file, this [backend config](./terraform/environments/backend.tfvars)

```bash
terraform init -backend-config ./environments/backend.tfvars
```

### Terraform Validate

Validate code syntax

```bash
terraform validate
```

### Terraform Plan

Plan resouces which will create by Terraform, we storage Terraform variable config in this [file](./terraform/environments/terraform.tfvars.json) and export `planfile.tfplan` file

```bash
terraform plan -out planfile.tfplan -var-file ./environments/terraform.tfvars.json
```

### Terraform Apply

Finally, we will apply above `planfile.tfplan` file

```bash
terraform apply planfile.tfplan -auto-approve
```