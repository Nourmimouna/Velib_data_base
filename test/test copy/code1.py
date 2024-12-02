import json
#J'importe mon fichier json, que j'ai copié coller du open data de velib de la ville de paris donc c'est des vrais stations de la ville de paris 
# Ce fichier python srt à remplir  dans un premier temps ma tables adresse et ensuite station

# le resulat de ce script est inserts_station_adresse.sql comme on a besoin d'une adresse pour creer une station je le fais en meme temps

# Charger le fichier JSON
with open('station.json') as f:
    data = json.load(f)
    count = 0

# Ouvrir le fichier inserts_station_adresse.sql en mode écriture
with open('inserts_station_adresse.sql', 'w') as sql_file:
    # Insertion des adresses et des stations
#ici je choisis de mettre 15 stations pour faciliter mon travail mais ceci peut etre ajuste juste en modifiant la condition sur count 

    for station in data['data']['stations']:
        if count >= 15:
            break  # Stopper après count stations
        
        lat = station['lat']
        lon = station['lon']
        # Insertion de l'adresse
        sql_file.write(f"INSERT INTO adresse (latitude, longitude) VALUES ({lat}, {lon});\n")
        
        # Remplacer les apostrophes dans le nom de la station
        station_name = station['name'].replace("'", "''")
        
        # Utilisation de count comme adresse_id pour la station
        sql_file.write(f"INSERT INTO station (station_id, nom, adresse_id, capacite) VALUES ({count}, '{station_name}', {count+1}, {station['capacity']});\n")
        
        count += 1
#pour verifier que c'est bon je fais ce printf mais cest pas obligatoire :) 
print("Le fichier 'inserts_station_adresse.sql' a été généré avec succès.")
