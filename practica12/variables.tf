variable "credenciales_azure" {
    type = object({
        client_id = string
        client_secret = string
        tenant_id = string
        subscription_id = string
    })
    sensitive = true
}
