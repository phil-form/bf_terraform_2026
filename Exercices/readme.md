# Exercice 01

Configurer une infra AWS avec deux ressources (linux)

L'une doit être dupliquée deux fois.

Sélectionner l'AMI via une query (data), et faites en sorte que l'on puisse changer facilement le type d'instance.

Faites sortir un objet renvoyant : 
- l'id de chaque instance
- l'ip publique de chaque instance

# Exercice 02

En repartant de l'exercice précédent, ajouter une  gestion de réseaux.

Faites trois réseaux distinct :
- public 3 sous réseaux (port ouvert 22, 80, 8080, 443) 
- privé 2 sous réseaux (port ouvert 22, 5432)

# Exercice 03

En partant de l'exo 2, configurer un environment capable de travailler avec des variables différentes entre le dev, le stagging et la prod

# Exercice 04

## Architecture Infrastructure

### Vue générale

                       Internet
                           │
                           ▼
                  ┌─────────────────┐
                  │ Internet Gateway│
                  └─────────────────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │ Public Subnets x4│
                  ├─────────────────┤
                  │ Connexions :    │
                  │ - HTTPS         │
                  │ - SSH           │
                  │ - SFTP          │
                  │ NAT Gateway      │
                  │ (via Subnet 1)  │
                  └─────────────────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │ Private Subnets x5│
                  ├─────────────────┤
                  │ Connexions :    │
                  │ - SSH           │
                  │ - SFTP          │
                  │ - SQL Server    │
                  └─────────────────┘



---

## Modules à créer

1. **Réseau (`network`)**
    - VPC
    - Subnets publics et privés
    - Route tables
    - Internet Gateway
    - NAT Gateway

2. **Web (`web`) x 4**
    - Instances ou services web
    - Security Groups (HTTP/HTTPS/SSH)
    - Load Balancers (si nécessaire)

3. **Base de données (`db`) x 5**
    - Instances ou services DB
    - Security Groups (SQL Server, SSH/SFTP)
    - ⚠️ Attention : Les vrais services DB ne sont pas disponibles avec LocalStack

4. **Stockage (`storage`) x 5**
    - Buckets ou systèmes de stockage
    - Permissions / IAM
    - ⚠️ Attention : Les vrais services de stockage ne sont pas disponibles avec LocalStack

---

## Environments

- **Environments prévus :** `dev`, `staging`, `prod`
- Utilisation des **workspaces Terraform** pour gérer dynamiquement les variables selon l’environnement
    - Chaque workspace modifie automatiquement les valeurs des variables
    - Exemple : CIDR, nombre de subnets, configurations spécifiques à l’environnement
- Permet de déployer la même architecture avec des paramètres différents selon l’environnement

---

## Notes importantes

- **NAT Gateway** : passe par le **Public Subnet 1** pour fournir l’accès Internet aux subnets privés
- **Sécurité** :
    - Public Subnets : HTTPS, SSH, SFTP
    - Private Subnets : SSH, SFTP, SQL Server
- **Modules indépendants** pour favoriser la réutilisation et la maintenabilité
- **Workspaces Terraform** permettent de séparer clairement les environnements sans dupliquer le code