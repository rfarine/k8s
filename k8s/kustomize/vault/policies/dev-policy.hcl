# DEV VAULT POLICY
# This section grants all access on "secret/*".
path "api/*" {
  capabilities = ["create", "read", "update", "list"]
}

path "shared/*" {
  capabilities = ["create", "read", "update", "list"]
}

path "react/*" {
  capabilities = ["create", "read", "update", "list" ]
}
