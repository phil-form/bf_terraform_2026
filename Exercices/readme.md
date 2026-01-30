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