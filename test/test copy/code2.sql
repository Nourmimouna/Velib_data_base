
--ce fichier sert a ajouter un trigger sur la table velo qui verifie la note du velo est ajoute une maintenance dans la table maintenance si la note du velo est inferieur à 3 

CREATE OR REPLACE FUNCTION trigger_ajouter_maintenance()
RETURNS TRIGGER AS $$
DECLARE
    note_velo FLOAT;
    gravite_maintenance gravite_maintenance;
BEGIN
    -- Récupérer la note moyenne du vélo
    SELECT note_moyenne INTO note_velo FROM velo WHERE velo_id = NEW.velo_id;

    -- Déterminer la gravité de la maintenance
    IF note_velo >= 5 THEN
        gravite_maintenance := 'FAIBLE'::gravite_maintenance;
    ELSIF note_velo >= 3 THEN
        gravite_maintenance := 'MOYENNE'::gravite_maintenance;
    ELSE
        gravite_maintenance := 'CRITIQUE'::gravite_maintenance;
    END IF;

    -- Insérer un enregistrement dans la table Maintenance
    INSERT INTO maintenance (velo_id, technicien_id, date_debut, date_fin, gravite)
    VALUES (
        NEW.velo_id,
        (SELECT technicien_id FROM technicien ORDER BY RANDOM() LIMIT 1), -- Technicien aléatoire
        CURRENT_TIMESTAMP - INTERVAL '1 DAY', -- Date de début fictive
        CURRENT_TIMESTAMP,                    -- Date de fin fictive
        gravite_maintenance
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_ajouter_maintenance
AFTER UPDATE ON velo
FOR EACH ROW
WHEN (NEW.statut = 'DISPONIBLE')
EXECUTE FUNCTION trigger_ajouter_maintenance();

