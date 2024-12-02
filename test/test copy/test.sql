
--cets le fichier de teste de la base je genere un feedback et un trajet pour voir si cets mis a jour dans le velo correspondant 
--j'ai essayer de creer uen sorte de communication avce le terminal pour simuler le teste sur le terminal

-- Message d'introduction
\echo '===== Début des tests ====='


-- Étape 1 : Générer des trajets pour un vélo
\echo 'Ma Base Velib Actuelle'

select * from station; 
select * from utilisateur; 
select * from velo; 

SELECT * FROM velo WHERE velo_id = 1;


INSERT INTO trajet (velo_id, date_heure_depart, date_heure_arrivee, station_depart_id, station_arrivee_id)
VALUES (1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 minutes', 1, 2);


-- Vérification après mise à jour du nombre de trajets
\echo 'Nombre de trajet du velo de id 1 après le trajet'

SELECT * FROM velo WHERE velo_id = 1;



-- Étape 2 : Ajouter un feedback pour un vélo
\echo '== SIMULATION FEEDBACK =='

\echo 'velo de id 2 avant le feedback'

SELECT * FROM velo WHERE velo_id = 2;





INSERT INTO feedback (feedback_id, velo_id, client_id, note, commentaire, date_feedback)
VALUES (1, 2, 2, 5, 'PAS BIEN :( !', CURRENT_TIMESTAMP);


\echo 'velo de id 2 aprés le feedback'
SELECT * FROM velo WHERE velo_id = 2;



-- Vérification des vélos devenant indisponibles
\echo 'La table VELO :'
SELECT * FROM velo ;

-- Étape 4 : Créer un planning avec des visites
\echo '== Création de planning et de visites =='
-- je genere un planning et je fixe son id pour les testes d'apres 

SELECT generate_planning(1);

SELECT * FROM planning WHERE planning_id = 1;

SELECT * FROM visite WHERE planning_id = 1;


SELECT * FROM historiqueMaintenance ;


-- Étape 5 : Remettre les vélos en station
\echo '== Retour des vélos aux stations =='

select retour_velo(1); 



-- Retourner les vélos en maintenance à une station
\echo '    Mise à jour des vélos retournés et disponibles...'


-- Vérification après retour des vélos
\echo 'Vérification des vélos remis en station :'
SELECT * FROM velo ;
SELECT * FROM historiqueMaintenance;

\echo '===== Fin des tests ====='
