from faker import Faker
import random
#Ce fichier sert a remplir les tables utilisateurs clients, technicien et responsable est ecris ces requets dans inserts_user.sql
# Initialisation de la bibliothèque Faker
fake = Faker('fr_FR')

# Nombre d'entrées pour chaque type d'utilisateur
num_clients = 10
num_responsables = 1
num_techniciens = 2

# Ouvrir le fichier SQL en mode écriture
with open('inserts_users.sql', 'w') as sql_file:
    # Générer les clients
    for _ in range(num_clients):
        nom = fake.last_name().replace("'", "''")
        prenom = fake.first_name().replace("'", "''")
        email = fake.email().replace("'", "''")
        mot_de_passe = fake.password(length=10)
        abonnement = random.choice(['MENSUEL', 'ANNUEL'])
        
        # Requêtes SQL pour insérer un utilisateur et un client
        sql_file.write(
            f"INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, type_utilisateur) "
            f"VALUES ('{nom}', '{prenom}', '{email}', '{mot_de_passe}', 'CLIENT');\n"
        )
        sql_file.write(
            f"INSERT INTO client (client_id, abonnement) "
            f"VALUES (currval('utilisateur_utilisateur_id_seq'), '{abonnement}');\n"
        )
    
    # Générer les responsables
    for _ in range(num_responsables):
        nom = fake.last_name().replace("'", "''")
        prenom = fake.first_name().replace("'", "''")
        email = fake.email().replace("'", "''")
        mot_de_passe = fake.password(length=10)
        zone_gestion = fake.city().replace("'", "''")
        
        # Requêtes SQL pour insérer un utilisateur et un responsable
        sql_file.write(
            f"INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, type_utilisateur) "
            f"VALUES ('{nom}', '{prenom}', '{email}', '{mot_de_passe}', 'RESPONSABLE');\n"
        )
        sql_file.write(
            f"INSERT INTO responsable (responsable_id, zone_gestion) "
            f"VALUES (currval('utilisateur_utilisateur_id_seq'), '{zone_gestion}');\n"
        )
    
    # Générer les techniciens
    for _ in range(num_techniciens):
        nom = fake.last_name().replace("'", "''")
        prenom = fake.first_name().replace("'", "''")
        email = fake.email().replace("'", "''")
        mot_de_passe = fake.password(length=10)
        specialite = random.choice(['REPARATION', 'ENTRETIEN', 'INSPECTION'])
        
        # Requêtes SQL pour insérer un utilisateur et un technicien
        sql_file.write(
            f"INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, type_utilisateur) "
            f"VALUES ('{nom}', '{prenom}', '{email}', '{mot_de_passe}', 'TECHNICIEN');\n"
        )
        sql_file.write(
            f"INSERT INTO technicien (technicien_id, specialite) "
            f"VALUES (currval('utilisateur_utilisateur_id_seq'), '{specialite}');\n"
        )

print("Le fichier 'inserts_users.sql' a été généré avec succès.")
