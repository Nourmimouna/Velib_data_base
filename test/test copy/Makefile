DB_NAME=velib_test
USER=postgres
HOST=localhost
PORT=5432
PGPASSWORD=NouSr2003

.PHONY: all test clean

all: reset setup python_prepare python_exports python_run inserts create_csv test create_1 python_carte 

# ce make file est crucial dans le teste de ma base faut creer une base et modifier les informations en haut , nom de base , mot de passe 
# l'ordre est notemment imoportant ici car les fichiers dépendent les uns des autres. 
# a la fin on genere une caret avec les stations et l'ordre de visite 

reset:
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -c "DROP SCHEMA public CASCADE;"
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -c "CREATE SCHEMA public;"
# Étape 1 : Exécute les scripts SQL dans l'ordre pour créer les tables et triggers
setup:
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -f code1.sql
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -f code2.sql
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -f code3.sql
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -f code4.sql
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -f code5.sql

# Étape 2 : Exécute code1.py pour générer inserts_station_adresse.sql
python_prepare:
	python3 code1.py

# Étape 3 : Exporte les données pour station et entrepôt dans des fichiers CSV
python_exports:
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -f inserts_station_adresse.sql
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -f inserts_entrepot.sql
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -f inserts_velo.sql

	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -c "\copy (SELECT station_id FROM station) TO 'stations.csv' CSV HEADER;"

	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -c "\copy (SELECT entrepot_id FROM entrepot) TO 'entrepots.csv' CSV HEADER;"

# Étape 4 : Exécute les scripts Python suivants pour générer d'autres données basées sur les exports
python_run:
	python3 code2.py
	python3 code3.py

# Étape 5 : Insère les autres données initiales
inserts:
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -f inserts_velo.sql
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -f inserts_users.sql

# Étape 6 : Tests et vérifications
test:
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -f test.sql

# Exporter les stations et adresses associées à l'id_planning = 1
# Exporter les stations avec adresse, latitude, longitude et ordre pour planning_id = 1
create_csv : 


	
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -c "\copy (SELECT e.entrepot_id, e.nom, a.adresse_id, a.latitude, a.longitude FROM entrepot e JOIN adresse a ON e.adresse_id = a.adresse_id) TO 'entrepots_adresse.csv' DELIMITER ',' CSV HEADER;"
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -c "\copy (SELECT s.station_id, s.nom, a.adresse_id, a.latitude, a.longitude FROM station s JOIN adresse a ON s.adresse_id = a.adresse_id) TO 'stations_adresse.csv' DELIMITER ',' CSV HEADER;"
create_1 : 	
	PGPASSWORD=$(PGPASSWORD) psql -U $(USER) -h $(HOST) -p $(PORT) -d $(DB_NAME) -c "\copy (SELECT a.station_id, v.ordre FROM station a JOIN visite v ON a.station_id = v.station_id WHERE v.planning_id = 1 ) TO 'adresses_ordre.csv' DELIMITER ',' CSV HEADER;"

	



python_carte : 
	python3 carte.py
# Nettoyage des fichiers CSV générés
clean:
	rm -f stations.csv entrepots.csv inserts_station_adresse.sql inserts_velo.sql inserts_users.sql entrepots_adresse.csv adresses_ordre.csv stations_adresse.csv carte_planning.html 
