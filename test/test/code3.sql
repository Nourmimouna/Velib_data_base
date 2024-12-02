CREATE OR REPLACE FUNCTION trigger_recuperer_velo_condition()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.statut = 'FAIT' THEN
        -- Ajouter une entrée dans historiqueMaintenance
        INSERT INTO historiqueMaintenance (camion_id, velo_id, statut, date)
        VALUES (NEW.planning_id, NEW.station_id, 'RECUP', CURRENT_TIMESTAMP);

        -- Mettre à jour les informations du vélo
        UPDATE velo
        SET statut = 'MAINTENANCE',
            station_id = NULL,
            entrepot_id = (SELECT entrepot_id 
                           FROM camion
                           WHERE camion.id = NEW.planning_id)
        WHERE id = NEW.station_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_recuperation_condition
AFTER UPDATE ON visite
FOR EACH ROW
WHEN (NEW.statut = 'FAIT')
EXECUTE FUNCTION trigger_recuperer_velo_condition();


CREATE OR REPLACE FUNCTION trigger_recuperer_velo_condition()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.statut = 'FAIT' THEN
        -- Ajouter une entrée dans historiqueMaintenance
        INSERT INTO historiqueMaintenance (camion_id, velo_id, statut, date)
        VALUES (NEW.planning_id, NEW.velo_id, 'RECUP', CURRENT_TIMESTAMP);

        -- Mettre à jour les informations du vélo
        UPDATE velo
        SET statut = 'MAINTENANCE',
            station_id = NULL,
            entrepot_id = (SELECT entrepot_id 
                           FROM camion
                           WHERE camion.camion_id = NEW.planning_id)
        WHERE velo_id = NEW.velo_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_recuperation_condition
AFTER UPDATE ON visite
FOR EACH ROW
WHEN (NEW.statut = 'FAIT')
EXECUTE FUNCTION trigger_recuperer_velo_condition();


