# Hashicorp Vault Configuration

## Hashicorp Cloud 
https://portal.cloud.hashicorp.com/
### Note
* If using Azure Firewall, use the Network Policy instead of Application Policy

## Setup Vault 
https://cloud.hashicorp.com/docs/vault
https://learn.hashicorp.com/tutorials/cloud/get-started-vault?in=vault/cloud

## Setup PKI
https://www.vaultproject.io/docs/secrets/pki
### Note
* Add CertSign, CRLSign, and DataEncipherment as options in the Key Usage section of the PKI Role
* Allow bare domains 
* Add Issuing certificates and CRL Distribution Points URLs 

## Configure AppRole
https://www.vaultproject.io/docs/auth/approle
https://learn.hashicorp.com/tutorials/vault/approle#step-4-login-with-roleid-secretid

```
vault policy write pki_policy -<<EOF
path "pki/*" { 
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOF

vault write auth/approle/role/bjdazure-dot-tech secret_id_ttl=8760h token_policies=pki_policy token_ttl=1h token_max_ttl=4h
vault read auth/approle/role/bjdazure-dot-tech/role-id
vault write -f auth/approle/role/bjdazure-dot-tech/secret-id
```
