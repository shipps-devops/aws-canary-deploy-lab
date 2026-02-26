terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # Ensinando o Terraform a baixar o plugin do Helm
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
}

# Diretor 1: Cuida da Nuvem AWS
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "Lab"
      Project     = "Canary-Deploy-From-Scratch"
      ManagedBy   = "Terraform"
    }
  }
}

# Diretor 2: Cuida de instalar pacotes DENTRO do Kubernetes
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}