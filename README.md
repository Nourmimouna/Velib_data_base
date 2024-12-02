# Velib_data_base

Vue d'ensemble
Ce projet consiste à analyser les données ouvertes du système Vélib' Métropole. Ces données contiennent des informations sur la disponibilité des vélos et des stations à travers Paris. L'objectif est d'explorer les tendances d'utilisation, d'analyser la performance des stations et d'optimiser la répartition des vélos dans la ville.

Instructions
1. Créer la base de données velib_test
Avant de pouvoir lancer le projet, vous devez créer une base de données MySQL appelée velib_test. Voici les étapes à suivre :

Connectez-vous à votre serveur MySQL ou MariaDB.
Créez la base de données en exécutant la commande suivante :
sql
Copier le code
CREATE DATABASE velib_test;
2. Modifier le mot de passe dans le Makefile
Dans le fichier Makefile, vous devez définir un mot de passe pour la connexion à la base de données. Ouvrez le fichier Makefile et remplacez la valeur du mot de passe par celui que vous souhaitez utiliser pour accéder à votre base de données MySQL.

Cherchez cette ligne dans le Makefile :

bash
Copier le code
MYSQL_PASSWORD=motdepasse
Remplacez motdepasse par votre propre mot de passe.

3. Lancer le projet
Une fois la base de données créée et le mot de passe modifié dans le Makefile, vous pouvez lancer le projet. Ouvrez un terminal et exécutez la commande suivante :

bash
Copier le code
make
Cela va démarrer le processus de récupération des données, leur insertion dans la base de données et la génération de la carte.

4. Visualiser la carte
Après avoir exécuté make, un fichier HTML sera généré pour visualiser le planning des stations Vélib'. Ouvrez le fichier planning_html dans votre navigateur pour voir la carte avec les stations et leurs informations.
