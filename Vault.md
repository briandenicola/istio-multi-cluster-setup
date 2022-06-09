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
    vault write pki/root/generate/internal common_name=bjdazure-dot-tech ttl=8760h
    vault read pki/roles/bjdazure-dot-tech
        Key                                Value                                                                                                                  
        allow_any_name                     true                                                                                                                   
        allow_bare_domains                 true                                                                                                                   
        allow_glob_domains                 true                                                                                                                   
        allow_ip_sans                      true                                                                                                                   
        allow_localhost                    true                                                                                                                   
        allow_subdomains                   true                                                                                                                   
        allow_token_displayname            false                                                                                                                  
        allow_wildcard_certificates        true                                                                                                                   
        allowed_domains                    ["bjdazure.tech","cluster.local","istio-system.svc","svc.cluster.local"]                                               
        allowed_domains_template           false                                                                                                                  
        allowed_other_sans                 []                                                                                                                     
        allowed_serial_numbers             []                                                                                                                     
        allowed_uri_sans                   ["cluster.local","istiod.istio-system.svc","istio-system.svc.cluster.local","spiffe://cluster.local/ns/*"]
        allowed_uri_sans_template          true                                                                                                                   
        basic_constraints_valid_for_non_ca false                                                                                                                  
        client_flag                        true                                                                                                                   
        code_signing_flag                  false                                                                                                                  
        country                            []                                                                                                                     
        email_protection_flag              false                                                                                                                  
        enforce_hostnames                  true                                                                                                                   
        ext_key_usage                      []                                                                                                                     
        ext_key_usage_oids                 []                                                                                                                     
        generate_lease                     false                                                                                                                  
        key_bits                           2048                                                                                                                   
        key_type                           rsa                                                                                                                    
        key_usage                          ["DigitalSignature","KeyAgreement","KeyEncipherment","CertSign","CRLSign","DataEncipherment"]                          
        locality                           []                                                                                                                     
        max_ttl                            2592000                                                                                                                 
        no_store                           false                                                                                                                  
        not_after                                                                                                                                                 
        not_before_duration                30                                                                                                                     
        organization                       []                                                                                                                     
        ou                                 []                                                                                                                     
        policy_identifiers                 []                                                                                                                     
        postal_code                        []                                                                                                                     
        province                           []                                                                                                                     
        require_cn                         false                                                                                                                  
        server_flag                        true                                                                                                                   
        signature_bits                     256                                                                                                                    
        street_address                     []                                                                                                                     
        ttl                                0                                                                                                                      
        use_csr_common_name                true                                                                                                                   
        use_csr_sans                       true                                                                                           
    vault read pki/config/urls
        Key                     Value                                                                                                        
        crl_distribution_points ["https://bjdazuretech.vault.77efcb74-6489-4e26-8333-65c5886cee01.aws.hashicorp.cloud:8200/v1/pki/crl"]
        issuing_certificates    ["https://bjdazuretech.vault.77efcb74-6489-4e26-8333-65c5886cee01.aws.hashicorp.cloud:8200/v1/pki/ca"] 
        ocsp_servers            []   
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

