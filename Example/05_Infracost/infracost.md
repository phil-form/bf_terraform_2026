# Infracost

Infracost est un logiciel permettant de connaître le prix au mois d'une infrasctructure.

## Installation :

Linux :
```bash
curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh
```

Windows (avec chocolatry) :
```bash
choco install infracost
```

MacOs :
```bash
brew install infracost
```

## Utilisation :

Il faut d'abord s'enregistrer (récupérer l'api-key et le serveur de pricing)

```bash
infracost register 
```

Cette commande créé le fichier suivant :

```bash
/home/rmdir/.config/infracost/credentials.yml
```

contenu : 

```bash
version: "0.1"
api_key: SECRETAPI_KEY
pricing_api_endpoint: https://pricing.api.infracost.io
```

Récupérer le coût d'une infrasctructure : 

1) Se positionner dans le projet terraform et : 
```bash
infracost breakdown --path .
```

```terminaloutput
INFO Autodetected 2 Terraform projects across 1 root module
INFO Found Terraform project main-dev at directory . using Terraform var files stagging.tfvars.json, dev.tfvars.json
INFO Found Terraform project main-prod at directory . using Terraform var files stagging.tfvars.json, prod.tfvars.json

Project: main-dev

 Name                                                    Monthly Qty  Unit              Monthly Cost   
                                                                                                       
 module.network.aws_nat_gateway.nat                                                                    
 ├─ NAT gateway                                                  730  hours                   $32.85   
 └─ Data processed                                    Monthly cost depends on usage: $0.045 per GB     
                                                                                                       
 aws_instance.db[0]                                                                                    
 ├─ Instance usage (Linux/UNIX, on-demand, t2.micro)             730  hours                    $8.47   
 └─ root_block_device                                                                                  
    └─ Storage (general purpose SSD, gp2)                          8  GB                       $0.80   
                                                                                                       
 aws_instance.db[1]                                                                                    
 ├─ Instance usage (Linux/UNIX, on-demand, t2.micro)             730  hours                    $8.47   
 └─ root_block_device                                                                                  
    └─ Storage (general purpose SSD, gp2)                          8  GB                       $0.80   
                                                                                                       
 aws_instance.web[0]                                                                                   
 ├─ Instance usage (Linux/UNIX, on-demand, t2.micro)             730  hours                    $8.47   
 └─ root_block_device                                                                                  
    └─ Storage (general purpose SSD, gp2)                          8  GB                       $0.80   
                                                                                                       
 aws_instance.web[1]                                                                                   
 ├─ Instance usage (Linux/UNIX, on-demand, t2.micro)             730  hours                    $8.47   
 └─ root_block_device                                                                                  
    └─ Storage (general purpose SSD, gp2)                          8  GB                       $0.80   
                                                                                                       
 aws_instance.web[2]                                                                                   
 ├─ Instance usage (Linux/UNIX, on-demand, t2.micro)             730  hours                    $8.47   
 └─ root_block_device                                                                                  
    └─ Storage (general purpose SSD, gp2)                          8  GB                       $0.80   
                                                                                                       
 Project total                                                                                $79.19   

──────────────────────────────────
Project: main-prod

 Name                                                    Monthly Qty  Unit              Monthly Cost   
                                                                                                       
 module.network.aws_nat_gateway.nat                                                                    
 ├─ NAT gateway                                                  730  hours                   $32.85   
 └─ Data processed                                    Monthly cost depends on usage: $0.045 per GB     
                                                                                                       
 aws_instance.db[0]                                                                                    
 ├─ Instance usage (Linux/UNIX, on-demand, t2.micro)             730  hours                    $8.47   
 └─ root_block_device                                                                                  
    └─ Storage (general purpose SSD, gp2)                          8  GB                       $0.80   
                                                                                                       
 aws_instance.db[1]                                                                                    
 ├─ Instance usage (Linux/UNIX, on-demand, t2.micro)             730  hours                    $8.47   
 └─ root_block_device                                                                                  
    └─ Storage (general purpose SSD, gp2)                          8  GB                       $0.80   
                                                                                                       
 aws_instance.web[0]                                                                                   
 ├─ Instance usage (Linux/UNIX, on-demand, t2.micro)             730  hours                    $8.47   
 └─ root_block_device                                                                                  
    └─ Storage (general purpose SSD, gp2)                          8  GB                       $0.80   
                                                                                                       
 aws_instance.web[1]                                                                                   
 ├─ Instance usage (Linux/UNIX, on-demand, t2.micro)             730  hours                    $8.47   
 └─ root_block_device                                                                                  
    └─ Storage (general purpose SSD, gp2)                          8  GB                       $0.80   
                                                                                                       
 aws_instance.web[2]                                                                                   
 ├─ Instance usage (Linux/UNIX, on-demand, t2.micro)             730  hours                    $8.47   
 └─ root_block_device                                                                                  
    └─ Storage (general purpose SSD, gp2)                          8  GB                       $0.80   
                                                                                                       
 Project total                                                                                $79.19   

 OVERALL TOTAL                                                                              $158.38 

*Usage costs can be estimated by updating Infracost Cloud settings, see docs for other options.

──────────────────────────────────
48 cloud resources were detected:
∙ 12 were estimated
∙ 36 were free

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━┓
┃ Project                                            ┃ Baseline cost ┃ Usage cost* ┃ Total cost ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━╋━━━━━━━━━━━━┫
┃ main-dev                                           ┃           $79 ┃           - ┃        $79 ┃
┃ main-prod                                          ┃           $79 ┃           - ┃        $79 ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━┻━━━━━━━━━━━━┛
```