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

Au déploiement les variables seront chargées automatiquement en fonction du workspace sélectionné.