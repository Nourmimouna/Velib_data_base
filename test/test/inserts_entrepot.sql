-- Ajout de deux nouvelles adresses
INSERT INTO adresse (adresse_id, latitude, longitude) VALUES (101, 48.8566, 2.3522); -- adresse Nord

-- Ajout de deux nouveaux entrepôts avec une capacité de 100
INSERT INTO entrepot (entrepot_id, nom, adresse_id, capacite) VALUES (3, 'Entrepot_PARIS ', 101, 100); -- Entrepôt Nord


