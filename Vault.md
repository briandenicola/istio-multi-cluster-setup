# Hashicorp Vault Configuration

## Sign Up for Hashicorp Cloud 
### Reference 
* https://portal.cloud.hashicorp.com/
### Note
* If using Azure Firewall, use the Network Policy instead of Application Policy for accces to VAULT_ADDR
* VAULT_ADDR will be something like https://bjdazuretech.vault.77efcb74-6489-4e26-8333-65c5886cee01.aws.hashicorp.cloud:8200

## Setup Vault 
### Reference 
* https://cloud.hashicorp.com/docs/vault
* https://learn.hashicorp.com/tutorials/cloud/get-started-vault?in=vault/cloud

## Setup PKI
```
    vault secrets enable pki
    vault secrets tune -max-lease-ttl=8760h pki
    vault write -field=certificate pki/root/generate/internal common_name=bjdazure-dot-tech ttl=8760h
    vault write pki/roles/bjdazure-dot-tech \
        allowed_domains="bjdazure.tech","cluster.local","svc" \
        allow_subdomains=true \
        allow_bare_domains=true \
        allowed_uri_sans="cluster.local","istiod.istio-system.svc","istio-system.svc.cluster.local","spiffe://cluster.local/*" \
        require_cn=false \
        key_type=rsa \                         
        key_usage="DigitalSignature","KeyAgreement","KeyEncipherment","CertSign","CRLSign","DataEncipherment" \  
        max_ttl="8766h"
    vault write pki/config/urls                                                                                                      
        issuing_certificates="https://bjdazuretech.vault.77efcb74-6489-4e26-8333-65c5886cee01.aws.hashicorp.cloud:8200/v1/pki/crl" \
        crl_distribution_points="https://bjdazuretech.vault.77efcb74-6489-4e26-8333-65c5886cee01.aws.hashicorp.cloud:8200/v1/pki/ca"
```

### Reference
https://www.vaultproject.io/docs/secrets/pki

## Configure AppRole
```
vault auth enable approle
vault policy write pki_policy -<<EOF
path "pki/*" { 
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOF

vault write auth/approle/role/bjdazure-dot-tech secret_id_ttl=8760h token_policies=pki_policy token_ttl=1h token_max_ttl=4h
vault read auth/approle/role/bjdazure-dot-tech/role-id
vault write -f auth/approle/role/bjdazure-dot-tech/secret-id
```

### Reference 
https://www.vaultproject.io/docs/auth/approle
https://learn.hashicorp.com/tutorials/vault/approle#step-4-login-with-roleid-secretid

