variable "mng_group_name" {
    type = string
    default = "management_group"
}

variable "tags_name" {
    type = string
    default = "name"
}
variable "tags_value_1" {
    type = string
    default = "value_1"
}

variable "tags_value_2" {
    type = string
    default = "value_2"
}

variable "tags_value_3" {
    type = string
    default = "value_3"
}

variable "tags_value_4" {
    type = string
    default = "value_4"
}


variable "rg_name_1" {
    type = string
    default = "rg_1"
}

variable "rg_name_2" {
    type = string
    default = "rg_2"
}

variable "rg_name_3" {
    type = string
    default = "rg_3"
}

variable "rg_name_4" {
    type = string
    default = "rg_4"
}
variable "locations" {
    type = string
    default = "koreacentral"
}

variable "vnet_name_1" {
    type = string
    default = "vnet_1"
}

variable "vnet_space_1" {
    type = string
    default = "10.1.0.0/16"

}

variable "vnet_name_2" {
    type = string
    default = "vnet_2"
}

variable "vnet_space_2" {
    type = string
    default = "10.2.0.0/16"

}

variable "vnet_name_3" {
    type = string
    default = "vnet_3"
}

variable "vnet_space_3" {
    type = string
    default = "10.3.0.0/16"

}

variable "vnet_name_4" {
    type = string
    default = "vnet_4"
}

variable "vnet_space_4" {
    type = string
    default = "10.4.0.0/16"

}

variable "logs_name" {
    type = string
    default = "logs-name"
}

variable "logs_sku" {
    type = string
    default = "Standard"
}

variable "logs_day" {
    type = number
    default = "30"
}

variable "fw_sbn_space" {
    type = string
    default = "10.2.1.0/26"
}

variable "fw_pip_name" {
    type = string
    default = "fw_pip_name"
}
variable "vpn_pip_name" {
    type = string
    default = "vpn_pip_name"
}
variable "fw_pip_avzone" {
    type = string
    default = "No-Zone" #디폴트는 Zone-Redundant 
}
variable "vpn_pip_avzone" {
    type = string
    default = "No-Zone" #디폴트는 Zone-Redundant 
}
variable "fw_pip_sku" {
    type = string
    default = "Standard" #디폴트는 Basic / Standard 권장
}
variable "vpn_pip_sku" {
    type = string
    default = "Standard" #디폴트는 Basic / Standard 권장
}

variable "fw_name" {
    type = string
    default = "fw_name"
}

variable "ddos_name" {
    type = string
    default = "ddos_name"
}


variable "vpn_sbnet_space" {
    type = string
    default = "10.2.2.0/26"
}

variable "vpn_name" {
    type = string
    default = "vpn_name"
}

variable "vpn_type" {
    type = string
    default = "RouteBased"                    #RouteBased(Default), PolicyBased
  
}

variable "vpn_active_active" {
    type = string
    default = "false"
}

variable "vpn_enable_bgp" {
    type = string
    default = "false"
}

variable "vpn_sku" {
    type = string
    default = "VpnGw2"
}

variable "rsv_name" {
    type = string
    default = "rsv-name"
}

variable "rsv_sku" {
    type = string
    default = "Standard"                      #Standard, R50
}
