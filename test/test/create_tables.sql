SELECT velo_id FROM velo WHERE statut_velo = 'MAINTENANCE';

SELECT s.nom 
FROM station s 
WHERE s.station_id IN (
    SELECT DISTINCT station_id 
    FROM velo 
    WHERE statut_velo = 'INDISPONIBLE'
);

SELECT velo_id 
FROM trajet 
WHERE trajet_id IN (
    SELECT trajet_id 
    FROM (
        SELECT trajet_id, EXTRACT(HOUR FROM date_heure_depart) AS heure_depart 
        FROM trajet
    ) AS trajets_specifiques 
    WHERE heure_depart = 19
);

SELECT s.nom, s.adresse_id 
FROM station s 
JOIN adresse a ON s.adresse_id = a.adresse_id 
WHERE s.station_id IN (
    SELECT station_id 
    FROM velo 
    WHERE statut_velo = 'DISPONIBLE'
);

SELECT c.client_id 
FROM client c 
JOIN trajet t ON c.client_id = t.client_id 
LEFT JOIN feedback f ON c.client_id = f.client_id 
WHERE f.feedback_id IS NULL;


SELECT v.velo_id 
FROM trajet t 
RIGHT JOIN velo v ON t.velo_id = v.velo_id 
WHERE t.trajet_id IS NULL;


SELECT s.station_id AS id_station, 
	s.nom AS nom_station, 
	v.velo_id AS id_velo, 
	v.statut_velo AS statut_velo 
FROM station s 
FULL OUTER JOIN velo v ON s.station_id = v.station_id;

SELECT v.velo_id 
FROM velo v 
INNER JOIN station s ON v.station_id = s.station_id 
WHERE v.note_moyenne < 3;


SELECT v.velo_id, s.nom AS station_nom 
FROM velo v 
JOIN station s ON v.station_id = s.station_id 
WHERE v.statut_velo = 'DISPONIBLE';


CREATE VIEW vue_velos_localisation AS 
SELECT v.velo_id, v.statut, s.nom AS station_nom, e.nom AS entrepot_nom 
FROM velo v 
LEFT JOIN station s ON v.station_id = s.station_id 
LEFT JOIN entrepot e ON v.entrepot_id = e.entrepot_id;


CREATE VIEW vue_trajets_recents AS 
SELECT t.trajet_id, t.velo_id, t.client_id, t.date_heure_depart, t.date_heure_arrivee, t.distance 
FROM trajet t 
WHERE t.date_heure_depart >= CURRENT_DATE - INTERVAL '7 days';

SELECT velo_id, statut_velo , station_nom 
FROM vue_velos_localisation 
WHERE station_nom = 'Station Centrale' AND statut_velo = 'DISPONIBLE';

SELECT velo_id, SUM(distance) AS distance_totale 
FROM vue_trajets_recents 
WHERE velo_id = 1 
GROUP BY velo_id;

SELECT velo_id, statut_velo 
FROM velo 
WHERE statut_velo = 'DISPONIBLE' 
UNION 
SELECT velo_id, statut 
FROM velo 
WHERE statut_velo = 'MAINTENANCE';

SELECT t.velo_id 
FROM trajet t 
EXCEPT 
SELECT f.velo_id 
FROM feedback f;

SELECT utilisateur_id 
FROM signalement 
INTERSECT 
SELECT client_id AS utilisateur_id 
FROM feedback;
