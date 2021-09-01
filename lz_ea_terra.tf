provider "azurerm" {
#  version = " ~> 2.7"
    features {}
}
data "azurerm_subscription" "current" {
}

resource "azurerm_management_group" "example_parent" {
  display_name      = var.mng_group_name

  subscription_ids  = [
    data.azurerm_subscription.current.subscription_id,
  ]
}

resource "azurerm_resource_group" "moa-krc-com-mng-rg" {
  name      = var.rg_name_1                                             #랜딩 존 리소스 그룹 이름
  location  = var.locations                                                     #랜딩 존 리소스 그룹 지역
  tags      = {
    "${var.tags_name}" = var.tags_value_1
  }
}

resource "azurerm_virtual_network" "moa-krc-com-mng-vnet" {
  name                = var.vnet_name_1                                        #가상 네트워크 이름
  resource_group_name = azurerm_resource_group.moa-krc-com-mng-rg.name
  location            = var.locations                                                #가상 네트워크 지역

  address_space = [var.vnet_space_1]                                                     #vnet IP 대역
  tags      = {
    "${var.tags_name}" = var.tags_value_1
  }
}

resource "azurerm_log_analytics_workspace" "moa-krc-com-mng-logs" {              #Log Analytics Workspace
  name                = var.logs_name
  location            = var.locations
  resource_group_name = azurerm_resource_group.moa-krc-com-mng-rg.name
  sku                 = var.logs_sku                                               #SKU 설정 Default = free
  retention_in_days   = var.logs_day                                                       #보존 기간 설정 ~730 (days)
  
  tags      = {
    "${var.tags_name}" = var.tags_value_1
  } 
}


resource "azurerm_resource_group" "moa-krc-com-prd-rg" {
  name     = var.rg_name_2                                                #랜딩 존 리소스 그룹 이름
  location = var.locations                                                      #랜딩 존 리소스 그룹 지역
  tags      = {
    "${var.tags_name}" = var.tags_value_2
  }
}

resource "azurerm_virtual_network" "moa-krc-com-prd-vnet" {
  name                = var.vnet_name_2                                        #가상 네트워크 이름
  resource_group_name = azurerm_resource_group.moa-krc-com-prd-rg.name
  location            = var.locations                                                #가상 네트워크 지역

  address_space = [var.vnet_space_2]                                                     #vnet IP 대역
  tags      = {
    "${var.tags_name}" = var.tags_value_2
  }
}

resource "azurerm_subnet" "moa-krc-com-prd-fwsbnet" {                                 #방화벽에 사용될 서브넷
  name                 = "FirewallSubnet"
  resource_group_name  = azurerm_resource_group.moa-krc-com-prd-rg.name
  virtual_network_name = azurerm_virtual_network.moa-krc-com-prd-vnet.name
  address_prefixes     = [var.fw_sbn_space]                                              
}

resource "azurerm_public_ip" "moa-krc-com-prd-pip" {                                  #방화벽에 사용될 공용 IP
  name                = var.fw_pip_name
  location            = var.locations
  resource_group_name = azurerm_resource_group.moa-krc-com-prd-rg.name
  allocation_method   = "Static"                                                      
  sku                 = var.fw_pip_sku                                                #디폴트는 Basic / Standard 권장
  availability_zone   = var.fw_pip_avzone                                             #No-Zone으로 한국 중부는                                            
  tags      = {
    "${var.tags_name}" = var.tags_value_2
  }
}

resource "azurerm_firewall" "moa-krc-com-prd-fw" {                                    #Azure 방화벽
  name                = var.fw_name
  location            = var.locations
  resource_group_name = azurerm_resource_group.moa-krc-com-prd-rg.name
  tags      = {
    "${var.tags_name}" = var.tags_value_2
  }
}


resource "azurerm_network_ddos_protection_plan" "moa-krc-com-prd-ddos" {              #DDoS Protection
  name                = var.ddos_name
  location            = var.locations
  resource_group_name = azurerm_resource_group.moa-krc-com-prd-rg.name

  tags      = {
    "${var.tags_name}" = var.tags_value_2
  }  
}

resource "azurerm_subnet" "moa-krc-com-prd-vpnsbnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.moa-krc-com-prd-rg.name
  virtual_network_name = azurerm_virtual_network.moa-krc-com-prd-vnet.name
  address_prefixes     = [var.vpn_sbnet_space]
}

resource "azurerm_public_ip" "moa-krc-com-prd-vpnpip" {                                  #가상 네트워크 게이트웨이에 사용될 공용 IP
  name                = var.vpn_pip_name
  location            = var.locations
  resource_group_name = azurerm_resource_group.moa-krc-com-prd-rg.name
  allocation_method   = "Static"                                                      
  sku                 = var.vpn_pip_sku                                                #디폴트는 Basic / Standard 권장
  availability_zone   = var.vpn_pip_avzone                                             #No-Zone으로 한국 중부는                                            
  tags      = {
    "${var.tags_name}" = var.tags_value_2
  }
}

resource "azurerm_virtual_network_gateway" "moa-krc-com-prd-vpn" {
  name                = var.vpn_name
  location            = var.locations
  resource_group_name = azurerm_resource_group.moa-krc-com-prd-rg.name

  type          = "Vpn"
  vpn_type      = var.vpn_type
  active_active = "false"
  enable_bgp    = "false"
  sku           = var.vpn_sku

  ip_configuration {
    name                 = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.moa-krc-com-prd-vpnpip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.moa-krc-com-prd-vpnsbnet.id
  }
  tags      = {
    "${var.tags_name}" = var.tags_value_2
  }
}

resource "azurerm_recovery_services_vault" "moa-krc-com-prd-rsv" {
  name                = var.rsv_name
  location            = var.locations
  resource_group_name = azurerm_resource_group.moa-krc-com-prd-rg.name
  sku                 = var.rsv_sku
}
resource "azurerm_resource_group" "moa-krc-com-dev-rg" {
  name     = var.rg_name_3                                                #랜딩 존 리소스 그룹 이름
  location = var.locations                                                      #랜딩 존 리소스 그룹 지역
  tags      = {
    "${var.tags_name}" = var.tags_value_3
  }
}

resource "azurerm_virtual_network" "moa-krc-com-dev-vnet" {
  name                = var.vnet_name_3                                        #가상 네트워크 이름
  resource_group_name = azurerm_resource_group.moa-krc-com-dev-rg.name
  location            = var.locations                                                #가상 네트워크 지역

  address_space = [var.vnet_space_3]                                                     #vnet IP 대역
  tags      = {
    "${var.tags_name}" = var.tags_value_3
  }
}


resource "azurerm_resource_group" "moa-krc-com-stg-rg" {
  name     = var.rg_name_4                                               #랜딩 존 리소스 그룹 이름
  location = var.locations                                                      #랜딩 존 리소스 그룹 지역
  tags      = {
    "${var.tags_name}" = var.tags_value_4
  }
}

resource "azurerm_virtual_network" "moa-krc-com-stg-vnet" {
  name                = var.vnet_name_4                                        #가상 네트워크 이름
  resource_group_name = azurerm_resource_group.moa-krc-com-stg-rg.name
  location            = var.locations                                                #가상 네트워크 지역

  address_space = [var.vnet_space_4]                                                     #vnet IP 대역
  tags      = {
    "${var.tags_name}" = var.tags_value_4
  }
}
