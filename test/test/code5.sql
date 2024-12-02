CREATE OR REPLACE FUNCTION generate_planning(camion_id INT)
RETURNS VOID AS $$
DECLARE
    entrepot_coords RECORD;
    station_coords RECORD;
    stations_to_visit RECORD;
    current_capacity INT;
    new_planning_id INT;
    visit_order INT := 1;
    historique_id INT;
    velo_rec RECORD;  -- Déclarer la variable comme un RECORD pour itérer sur les vélos
BEGIN
    -- Récupérer les coordonnées GPS de l'entrepôt lié au camion
    SELECT a.latitude, a.longitude
    INTO entrepot_coords
    FROM camion c
    JOIN entrepot e ON c.entrepot_id = e.entrepot_id
    JOIN adresse a ON e.adresse_id = a.adresse_id
    WHERE c.camion_id = $1;  -- Utiliser $1 pour faire référence à la variable camion_id

    -- Créer un nouveau planning pour ce camion
    INSERT INTO planning (camion_id, date)
    VALUES ($1, CURRENT_DATE)
    RETURNING planning_id INTO new_planning_id;

    -- Initialiser la capacité du camion
    SELECT capacite INTO current_capacity FROM camion WHERE camion.camion_id = $1;

    -- Récupérer les stations avec des vélos indisponibles, triées par distance
    FOR stations_to_visit IN
        SELECT s.station_id, a.latitude, a.longitude, COUNT(v.velo_id) AS nb_velos
        FROM station s
        JOIN velo v ON s.station_id = v.station_id
        JOIN adresse a ON s.adresse_id = a.adresse_id  -- Joindre l'adresse pour récupérer latitude et longitude
        WHERE v.statut = 'INDISPONIBLE'
        GROUP BY s.station_id, a.latitude, a.longitude
        ORDER BY SQRT(POWER(a.latitude - entrepot_coords.latitude, 2) + POWER(a.longitude - entrepot_coords.longitude, 2))
    LOOP
        -- Vérifier si le camion a encore de la place
        IF current_capacity >= stations_to_visit.nb_velos THEN
            -- Ajouter une visite dans la table visite
            INSERT INTO visite (station_id, planning_id, ordre)
            VALUES (stations_to_visit.station_id, new_planning_id, visit_order);

            -- Insérer une ligne dans historiqueMaintenance avec l'état 'RECUP'
            FOR velo_rec IN 
                SELECT v.velo_id 
                FROM velo v
                WHERE v.station_id = stations_to_visit.station_id AND v.statut = 'INDISPONIBLE'
            LOOP
                -- Insérer l'entrée dans historiqueMaintenance pour chaque vélo récupéré
                INSERT INTO historiqueMaintenance (camion_id, velo_id, etat, date)
                VALUES ($1, velo_rec.velo_id, 'RECUP', CURRENT_TIMESTAMP);
                
                -- Mettre à jour le statut du vélo à 'MAINTENANCE'
                UPDATE velo
                SET statut = 'MAINTENANCE'
                WHERE velo_id = velo_rec.velo_id;

                RAISE NOTICE 'Le vélo % a été récupéré', velo_rec.velo_id;
            END LOOP;

            -- Réduire la capacité restante
            current_capacity := current_capacity - stations_to_visit.nb_velos;
            visit_order := visit_order + 1;
        ELSE
            -- Si le camion est plein, arrêter la planification
            EXIT;
        END IF;
    END LOOP;

    -- Modifier le statut du planning à 'FINI' après la fin de la planification
    UPDATE planning
    SET statut = 'FINI'
    WHERE planning_id = new_planning_id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION retour_velo(camion_id INT)
RETURNS VOID AS $$
DECLARE
    v RECORD; -- Renommé pour éviter les conflits avec la table velo
BEGIN
    -- Vérifier que le camion existe
    IF NOT EXISTS (SELECT 1 FROM camion c WHERE c.camion_id = retour_velo.camion_id) THEN
        RAISE EXCEPTION 'Le camion avec l''ID % n''existe pas.', camion_id;
    END IF;

    -- Itérer sur les vélos en maintenance
    FOR v IN 
        SELECT velo_id 
        FROM velo
        WHERE statut = 'MAINTENANCE'
    LOOP
        -- Insérer dans historiqueMaintenance
        INSERT INTO historiqueMaintenance (camion_id, velo_id, etat, date)
        VALUES (camion_id, v.velo_id, 'RETOUR', CURRENT_TIMESTAMP);

        -- Mettre à jour le statut du vélo
        UPDATE velo
        SET statut = 'DISPONIBLE'
        WHERE velo_id = v.velo_id;

        -- Message d'information pour chaque vélo retourné
        RAISE NOTICE 'Le vélo % est retourné et est maintenant DISPONIBLE.', v.velo_id;
    END LOOP;

    -- Message général si aucun vélo n'est en maintenance
    IF NOT FOUND THEN
        RAISE NOTICE 'Aucun vélo en maintenance n''a été retourné.';
    END IF;
END;
$$ LANGUAGE plpgsql;
