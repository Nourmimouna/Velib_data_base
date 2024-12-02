# Projet Vélib' - Visualisation des données Vélib'

Ce projet permet de récupérer, stocker et visualiser les données de Vélib' en utilisant une base de données MySQL et générer une carte du planning à partir des informations récupérées.

## Prérequis

- MySQL ou MariaDB installé
- Python 3.x
- Accès à l'API Vélib' Metropole pour récupérer les données
- Git installé sur votre machine

## Étapes d'installation

### 1. Créer la base de données `velib_test`

Avant de commencer, vous devez créer la base de données `velib_test`. Ouvrez votre terminal MySQL ou MariaDB et exécutez la commande suivante :

```sql
CREATE DATABASE velib_test;

### 2. modifier le mot de passe dans le Makefile

Ouvrez le fichier Makefile dans un éditeur de texte. Vous devez modifier la ligne contenant le mot de passe pour la base de données MySQL. Remplacez motdepasse par le mot de passe de votre utilisateur MySQL.

### 3. cloner le projet et Installer les dépendances Python

### 4. Make command 

