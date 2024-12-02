import json

# Charger le fichier JSON
with open('station.json') as f:
    data = json.load(f)
    count = 0

# Ouvrir le fichier inserts_station_adresse.sql en mode écriture
with open('inserts_station_adresse.sql', 'w') as sql_file:
    # Insertion des adresses et des stations
    for station in data['data']['stations']:
        if count >= 15:
            break  # Stopper après 100 stations
        
        lat = station['lat']
        lon = station['lon']
        # Insertion de l'adresse
        sql_file.write(f"INSERT INTO adresse (latitude, longitude) VALUES ({lat}, {lon});\n")
        
        # Remplacer les apostrophes dans le nom de la station
        station_name = station['name'].replace("'", "''")
        
        # Utilisation de count comme adresse_id pour la station
        sql_file.write(f"INSERT INTO station (station_id, nom, adresse_id, capacite) VALUES ({count}, '{station_name}', {count+1}, {station['capacity']});\n")
        
        count += 1

print("Le fichier 'inserts_station_adresse.sql' a été généré avec succès.")
