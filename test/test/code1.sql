-- Types ENUM pour certains attributs

CREATE TYPE statut_camion AS ENUM ('DISPONIBLE', 'EN DÉPLACEMENT', 'EN RÉPARATION');
CREATE TYPE gravite_maintenance AS ENUM ('FAIBLE', 'MOYENNE', 'CRITIQUE');
CREATE TYPE abonnement_client AS ENUM ('MENSUEL', 'ANNUEL');
CREATE TYPE type_utilisateur AS ENUM ('CLIENT', 'TECHNICIEN', 'RESPONSABLE');
CREATE TYPE statut_velo AS ENUM ('DISPONIBLE', 'MAINTENANCE', 'TRAJET', 'INDISPONIBLE');
-- Table Adresse
CREATE TABLE adresse (
    adresse_id SERIAL PRIMARY KEY,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION
);


-- Table Station
CREATE TABLE station (
    station_id SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    adresse_id INT REFERENCES adresse(adresse_id),
    capacite INT
);

-- Table Entrepôt
CREATE TABLE entrepot (
    entrepot_id SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    adresse_id INT REFERENCES adresse(adresse_id),
    capacite INT
);

-- Table Camion
CREATE TABLE camion (
    camion_id SERIAL PRIMARY KEY,
    entrepot_id INT REFERENCES entrepot(entrepot_id),
    capacite INT,
    statut statut_camion,
    adresse_id INT REFERENCES adresse(adresse_id)
   
);

-- Table Vélo
CREATE TABLE velo (
    velo_id SERIAL PRIMARY KEY,
    station_id INT REFERENCES station(station_id),
    entrepot_id INT REFERENCES entrepot(entrepot_id),
    nb_trajets INT,
    note_moyenne DOUBLE PRECISION,
    statut statut_velo
);

-- Table Utilisateur
CREATE TABLE utilisateur (
    utilisateur_id SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    mot_de_passe VARCHAR(255),
    type_utilisateur type_utilisateur
);

-- Table Technicien (hérite de Utilisateur)
CREATE TABLE technicien (
    technicien_id INT PRIMARY KEY REFERENCES utilisateur(utilisateur_id),
    specialite VARCHAR(100)
);

-- Table Client (hérite de Utilisateur)
CREATE TABLE client (
    client_id INT PRIMARY KEY REFERENCES utilisateur(utilisateur_id),
    abonnement abonnement_client
);

-- Table Responsable (hérite de Utilisateur)
CREATE TABLE responsable (
    responsable_id INT PRIMARY KEY REFERENCES utilisateur(utilisateur_id),
    zone_gestion VARCHAR(100)
);

-- Table Feedback
CREATE TABLE feedback (
    feedback_id SERIAL PRIMARY KEY,
    client_id INT REFERENCES client(client_id),
    velo_id INT REFERENCES velo(velo_id),
    note INT CHECK (note >= 1 AND note <= 5),
    commentaire TEXT,
    date_feedback TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Trajet
CREATE TABLE trajet (
    trajet_id SERIAL PRIMARY KEY,
    velo_id INT REFERENCES velo(velo_id),
    client_id INT REFERENCES client(client_id),
    station_depart_id INT REFERENCES station(station_id),
    station_arrivee_id INT REFERENCES station(station_id),
    date_heure_depart TIMESTAMP,
    date_heure_arrivee TIMESTAMP,
    distance DOUBLE PRECISION
);

-- Table Maintenance
CREATE TABLE maintenance (
    maintenance_id SERIAL PRIMARY KEY,
    velo_id INT REFERENCES velo(velo_id),
    technicien_id INT REFERENCES technicien(technicien_id),
    date_debut TIMESTAMP,
    date_fin TIMESTAMP,
    gravite gravite_maintenance
);

-- Table Planning
CREATE TABLE planning (
    planning_id SERIAL PRIMARY KEY,
    camion_id INT REFERENCES camion(camion_id),
    date TIMESTAMP,
    distance_totale DOUBLE PRECISION
);

-- Table Signalement
CREATE TABLE signalement (
    signalement_id SERIAL PRIMARY KEY,
    utilisateur_id INT REFERENCES utilisateur(utilisateur_id),
    velo_id INT REFERENCES velo(velo_id),
    description TEXT,
    date_signalement TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table HistoriqueMaintenance
CREATE TABLE historiqueMaintenance (
    historique_id SERIAL PRIMARY KEY, -- Clé primaire
    planning_id INT REFERENCES planning(planning_id) ON DELETE SET NULL,
    camion_id INT REFERENCES camion(camion_id) ON DELETE SET NULL, -- Permet de gérer la suppression
    velo_id INT REFERENCES velo(velo_id) ON DELETE CASCADE, -- Suppression en cascade si le vélo est supprimé
    etat VARCHAR(10) CHECK (etat IN ('RECUP', 'RETOUR')), -- Contraintes pour limiter les valeurs possibles
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Définit une date par défaut si non fournie
);


-- Table Visite
CREATE TABLE visite (
    planning_id INT NOT NULL REFERENCES planning(planning_id) ON DELETE CASCADE, -- Clé étrangère avec suppression en cascade
    station_id INT NOT NULL REFERENCES station(station_id) ON DELETE CASCADE,   -- Clé étrangère avec suppression en cascade
    ordre INT NOT NULL, -- Indique l'ordre de la visite dans le planning
    PRIMARY KEY (planning_id, station_id) -- Clé primaire composée
);


ALTER TABLE station ALTER COLUMN station_id TYPE BIGINT;

-- Ajouter le statut dans planning
ALTER TABLE planning ADD COLUMN statut VARCHAR(20) DEFAULT 'EN_ATTENTE';

-- Ajouter le statut dans visite
ALTER TABLE visite ADD COLUMN statut VARCHAR(20) DEFAULT 'A_FAIRE';

ALTER TABLE velo ALTER COLUMN velo_id TYPE BIGINT;

ALTER TABLE station ALTER COLUMN station_id TYPE BIGINT;

INSERT INTO camion (camion_id, statut, capacite)
VALUES (1, 'DISPONIBLE', 100);
