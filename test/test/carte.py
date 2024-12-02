import pandas as pd
import folium

# Charger les fichiers CSV
stations_adresse = pd.read_csv('stations_adresse.csv')
adresses_ordre = pd.read_csv('adresses_ordre.csv')
entrepots = pd.read_csv('entrepots_adresse.csv')

# Fusionner les données pour inclure les informations nécessaires
stations = pd.merge(adresses_ordre, stations_adresse[['station_id', 'nom', 'latitude', 'longitude']],
                    on='station_id', how='inner')

# Créer une carte centrée sur une position moyenne (Paris comme exemple)
moyenne_latitude = stations['latitude'].mean() if not stations.empty else entrepots['latitude'].mean()
moyenne_longitude = stations['longitude'].mean() if not stations.empty else entrepots['longitude'].mean()
carte = folium.Map(location=[moyenne_latitude, moyenne_longitude], zoom_start=12)

# Ajouter un encadré avec le titre "Planning" en rouge
folium.map.Marker(
    [moyenne_latitude, moyenne_longitude],
    icon=folium.DivIcon(html=f"""
        <div style="background-color:white; border: 2px solid black; padding: 5px; text-align: center; width: 150px;">
            <h4 style="color:red; margin: 0;">Planning</h4>
        </div>
    """)
).add_to(carte)

# Ajouter les stations à la carte
for _, station in stations.iterrows():
    popup_text = f"<b>{station['nom']}</b><br>Ordre: {station['ordre']}"
    folium.Marker(
        location=[station['latitude'], station['longitude']],
        popup=popup_text,
        icon=folium.Icon(color="blue", icon="info-sign")
    ).add_to(carte)

# Ajouter les entrepôts à la carte
for _, entrepot in entrepots.iterrows():
    popup_text = f"<b>{entrepot['nom']}</b>"
    folium.Marker(
        location=[entrepot['latitude'], entrepot['longitude']],
        popup=popup_text,
        icon=folium.Icon(color="red", icon="warehouse")
    ).add_to(carte)

# Sauvegarder la carte dans un fichier HTML
carte.save('carte_planning.html')

print("La carte avec le titre encadré a été générée et sauvegardée sous le nom 'carte_planning.html'.")
