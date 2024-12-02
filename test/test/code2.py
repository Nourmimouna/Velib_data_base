import random

# Nombre de vélos à simuler
nombre_velos = 10

# Charger les IDs des stations depuis un fichier CSV
with open('stations.csv', 'r') as f:
    next(f)  # Sauter l'en-tête
    stations = [line.strip() for line in f.readlines()]  # Liste des stations

with open('entrepots.csv', 'r') as f:
    next(f)  # Sauter l'en-tête
    entrepots = [int(line.strip()) for line in f.readlines()]  # Liste des entrepôts

# Ouvrir le fichier SQL pour écrire les instructions INSERT
with open('inserts_velo.sql', 'w') as file:
    for i in range(nombre_velos):
        velo_id = i + 1  # ID unique pour chaque vélo
        statut = random.choice(['DISPONIBLE', 'TRAJET', 'INDISPONIBLE'])  # Statut aléatoire
        nb_trajets = random.randint(0, 60)  # Nombre de trajets (0 à 60)
        note_moyenne = round(random.uniform(0, 10), 1)  # Note moyenne (0 à 10)

        # Initialisation des IDs
        station_id = "NULL"
        entrepot_id = "NULL"
        if nb_trajets > 40 or note_moyenne < 3 :
            statut = 'INDISPONIBLE'

        # Logique pour déterminer la station ou l'entrepôt
        if statut == 'DISPONIBLE':
            station_id = f"'{random.choice(stations)}'"  # Assigner à une station
       
        elif statut == 'INDISPONIBLE' or nb_trajets > 50 or note_moyenne < 3:
            station_id = f"'{random.choice(stations)}'"  # Assigner à un entrepôt
       
        elif statut == 'TRAJET':
            # Aucun station_id ni entrepot_id pour les vélos en trajet
            station_id = "NULL"
            entrepot_id = "NULL"

        # Rédaction de l'instruction SQL
        file.write(
            f"INSERT INTO velo (velo_id, station_id, nb_trajets, note_moyenne, statut, entrepot_id) "
            f"VALUES ({velo_id}, {station_id}, {nb_trajets}, {note_moyenne}, '{statut}', {entrepot_id});\n"
        )

print("Fichier 'inserts_velo.sql' généré avec succès!")
