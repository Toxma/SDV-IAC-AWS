# Phase 3 : Mise en œuvre de la haute disponibilité et de la capacité de mise à l'échelle élevée

## Architecture du repo

```plaintext
.
├── alb.tf #loadbalancer + targetgroup
├── asg.tf #scaling group + launch template
├── cloud9.tf #instance cloud9
├── database.tf #RDS
├── data.tf #data terraform
├── ec2.tf #instance ec2
├── keypair.tf #clé publique
├── providers.tf #providers nécessaires
├── main.tf #provider AWS
├── networks.tf #VPC, subnet, route table et IGW
├── outputs.tf #output terraform
└── user-data-p3.sh #Script webserver phase3
```

## Déploiement de l'infrastucture

1. Ajout des credentials AWS nécessaires au provider dans le fichier `main.tf`
2. `terraform init`
3. `terraform plan`
4. `terraform apply`

## Schéma d'architecture

![Schema](./src/phase3.drawio.png)

## Configuration

1. Déploiement de la phase 2
2. Déploiement du ALB
3. Déploiement du launch template
4. Déploiement du ASG
5. Ajout des target pour ALB depuis ASG
6. Test de scaling

## Capture réalisation phase 2

- Webserver phase1

![](./src/websrv-p1.png)

- Application loadbalancer

![](./src/alb_conf.png)

- Target group ALB

![](./src/targetgrp_conf.png)

- Configuration ASG

![](./src/asg_conf.png)

- Launch template pour ASG

![](./src/launch_template.png)

- ASG réglé sur 1 instance

![](./src/asg_to_1.png)

- Webserver depuis ALB

![](./src/web_lb_rds.png)

- Scale ASG à 2 instances

![](./src/asg_to_2.png)

- Target group après scale à 2 instances

![](./src/target_post_scale.png)