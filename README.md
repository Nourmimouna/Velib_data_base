# Projet Vélib' - Base de Données

# Projet Vélib' 🚲

Ce projet concerne la gestion d'un système de vélos en libre-service. Il vous permettra de mieux comprendre comment gérer une flotte de vélos et d'entrepôts. 💻 Il inclut la création de tables, l'insertion de données et des requêtes pour interroger la base. Le système comprend également des éléments pour la visualisation des stations et des entrepôts via des cartes.

## Structure du Projet

Le projet contient plusieurs fichiers organisés selon les différentes tâches et fonctionnalités du système.

### Fichiers de la Base de Données 🗄️

- **`inserts_*.sql`** : Ces fichiers contiennent les requêtes SQL pour insérer des données dans la base de données.
  - `inserts_entrepot.sql` : Insertion des données des entrepôts.
  - `inserts_station_adresse.sql` : Insertion des adresses des stations.
  - `inserts_users.sql` : Insertion des utilisateurs.
  - `inserts_velo.sql` : Insertion des vélos.

- **`code1.sql`, `code2.sql`, `code3.sql`, `code4.sql`, `code5.sql`** : Ces fichiers SQL contiennent des requêtes pour la création des tables et autres opérations liées à la gestion de la base de données.

- **`requetes.sql`** : Contient les requêtes pour interroger la base de données et récupérer des informations spécifiques, comme la liste des stations disponibles ou des utilisateurs actifs.

- **`test.sql`** : Utilisé pour tester les requêtes SQL et valider la structure de la base de données.

- **`adresses_ordre.csv`, `entrepots.csv`, `stations.csv`, `stations_adresse.csv`, `entrepots_adresse.csv`** : Ces fichiers CSV contiennent les données nécessaires à l'alimentation de la base de données. Ils sont utilisés pour insérer les informations sur les adresses, les entrepôts, les stations et les vélos.

### Fichiers Python

- **`code1.py`, `code2.py`, `code3.py`, `code4.py`, `code5.py`** : Scripts Python pour manipuler les données, effectuer des analyses ou générer des rapports. Ces scripts interagissent avec la base de données pour ajouter des informations, calculer des statistiques ou générer des vues.

- **`carte.py`** : Génère des données cartographiques et visualise les stations et les entrepôts. Ce script peut être utilisé pour créer des cartes interactives ou statiques.

### Fichiers HTML et JSON

- **`carte_planning.html`** : Fichier HTML généré pour afficher une carte ou un planning des stations et des entrepôts. Ce fichier contient une vue visuelle de la répartition des stations sur la carte.
  
- **`station.json`** : Contient des informations structurées sur les stations sous format JSON, utilisées pour la visualisation ou l'interrogation via des outils externes.

### Documentation

- **`Rapport_BDD_Vélib.pdf`** : Rapport détaillant la conception de la base de données, la structure des tables et les choix effectués pour le projet.

## Comment Installer et Tester le Projet 🚀

### Prérequis

1. **Base de données** : Ce projet utilise MySQL pour stocker les informations sur les stations, les entrepôts et les utilisateurs. Vous devez disposer d'un serveur MySQL opérationnel.

2. **Python** : Assurez-vous d'avoir Python installé sur votre machine. Le projet utilise des scripts Python pour manipuler les données.

3. **Bibliothèques Python** : Si vous utilisez des bibliothèques externes dans vos scripts Python, installez-les avec la commande suivante :
   ```bash
   pip install -r requirements.txt

Visualisation de la Carte 🗺️   
Voici une carte générée par le fichier carte_planning.html, qui montre l'emplacement des stations et des entrepôts.
