# Créer un workspace

```bash
terraform workspace new <nom_du_workspace>
```

# Lister les workspaces

```bash
terraform workspace list
```

# Changer de workspace

```bash
terraform workspace select <nom_du_workspace>
```

# Example déploiement en dev

```bash
terraform workspace select dev
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

# ou via les locals