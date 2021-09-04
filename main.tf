terraform {
 backend "remote" {
   organization = "jdpeckham"
   workspaces {
     name = "jdpeckham-dot-com"
   }
 }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
   azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
}
provider "aws" {
    region = "us-east-1"
}

resource "aws_route53_zone" "jdpeckham" {
  name = "jdpeckham.com"
  comment = "HostedZone created by Route53 Registrar"
}

resource "aws_route53_record" "azure-ns" {
  zone_id = aws_route53_zone.jdpeckham.zone_id
  name    = "azure.jdpeckham.com"
  type    = "NS"
  ttl     = "300"
  records = azurerm_dns_zone.azure.name_servers 
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-jdpeckham"
  location = "centralus"
}

resource "azurerm_dns_zone" "azure" {
  name                = "azure.jdpeckham.com"
  resource_group_name = azurerm_resource_group.rg.name
}