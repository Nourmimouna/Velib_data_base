CREATE OR REPLACE FUNCTION update_bike_status_on_signalement()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.description ~* '(bad|trous|ne marche pas|shit)' THEN
        UPDATE velo
        SET etat = 'INDISPONIBLE'
        WHERE velo_id = NEW.velo_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_bike_status_signalement
AFTER INSERT ON signalement
FOR EACH ROW
EXECUTE FUNCTION update_bike_status_on_signalement();



-- Fonction PL/pgSQL pour mettre à jour les statistiques du vélo après un feedback
-- Fonction PL/pgSQL pour mettre à jour les statistiques du vélo après un feedback
CREATE OR REPLACE FUNCTION update_bike_status_on_feedback()
RETURNS TRIGGER AS $$
DECLARE
    current_nb_trajets INTEGER;
    current_note_moyenne NUMERIC;
BEGIN
    -- Récupérer les valeurs actuelles de nb_trajets et note_moyenne pour le vélo
    SELECT velo.nb_trajets, velo.note_moyenne INTO current_nb_trajets, current_note_moyenne
    FROM velo
    WHERE velo_id = NEW.velo_id;

    -- Si le vélo a déjà des trajets, mettre à jour les statistiques
    IF current_nb_trajets > 0 THEN
        UPDATE velo
        SET 
            note_moyenne = (current_note_moyenne * current_nb_trajets + NEW.note) / (current_nb_trajets + 1)
            
        WHERE velo_id = NEW.velo_id;
    ELSE
        -- Si le vélo n'a pas de trajets, initialiser les statistiques
        UPDATE velo
        SET 
            note_moyenne = NEW.note
           
        WHERE velo_id = NEW.velo_id;
    END IF;

    -- Vérifier si la note moyenne est inférieure à 3 pour changer l'état
    SELECT velo.note_moyenne INTO current_note_moyenne
    FROM velo
    WHERE velo_id = NEW.velo_id;

    IF current_note_moyenne < 3 THEN
        UPDATE velo
        SET statut = 'INDISPONIBLE'
        WHERE velo_id = NEW.velo_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer le trigger associé à la table feedback
CREATE TRIGGER trg_update_bike_status_feedback
AFTER INSERT ON feedback
FOR EACH ROW
EXECUTE FUNCTION update_bike_status_on_feedback();


-- Supprimer le trigger existant
CREATE OR REPLACE FUNCTION update_trajet_and_note()
RETURNS TRIGGER AS $$
DECLARE
    avg_note NUMERIC;
BEGIN
    -- Calcul de la moyenne des notes pour le vélo
    SELECT AVG(note)::NUMERIC INTO avg_note
    FROM feedback
    WHERE velo_id = NEW.velo_id;

    -- Mise à jour du vélo avec le nombre de trajets et la note moyenne
    UPDATE velo
    SET 
        nb_trajets = nb_trajets + 1,
        note_moyenne = COALESCE(avg_note, 0),
        station_id = NEW.station_arrivee_id  -- Assurez-vous que "station_arrivee" est bien le nom correct
    WHERE velo_id = NEW.velo_id;

    -- Vérification de la note moyenne et mise à jour de l'état du vélo
    IF COALESCE(avg_note, 0) < 3 THEN
        UPDATE velo
        SET statut = 'INDISPONIBLE'
        WHERE velo_id = NEW.velo_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer à nouveau le trigger
CREATE TRIGGER trg_update_trajet_and_note
AFTER INSERT ON trajet
FOR EACH ROW
EXECUTE FUNCTION update_trajet_and_note();
