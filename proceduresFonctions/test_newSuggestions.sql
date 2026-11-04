SET SERVEROUTPUT ON;

BEGIN
    -- Insérer des données de test
    DBMS_OUTPUT.PUT_LINE('== TEST NEW SUGGESTIONS TO SUGGESTIONS TABLE==');

    DBMS_OUTPUT.PUT_LINE('Insertion des données de test...');
    
    -- Insérer des utilisateurs
    INSERT INTO Utilisateur (user_id, login, email, mdp, prenom, nom, date_naissance, abo_newsletter, pays_origine) 
    VALUES (1001, 'user1001', 'user1001@example.com', 'password1001', 'Prenom1001', 'Nom1001', ADD_MONTHS(SYSDATE, -12*20), 0, 'France');
    
    
    -- Insérer des émissions
    INSERT INTO Emission (emission_id, titre, nom_categorie, description) VALUES (1001, 'Emission 1001', 'comedy', 'Description Emission 1001');
    INSERT INTO Emission (emission_id, titre, nom_categorie, description) VALUES (1002, 'Emission 1002', 'drama', 'Description Emission 1002');
    
    -- Insérer des vidéos
    INSERT INTO Video (video_id, emission_id, episode_num, titre, description, duree, image_format, pays_origine, date_sortie, multilangage, date_publication)
    VALUES (1001, 1001, 1, 'Episode 1', 'Description 1', 60, '8k', 'France', SYSDATE - INTERVAL '10' DAY, 0, SYSDATE - INTERVAL '10' DAY );
    INSERT INTO Video (video_id, emission_id, episode_num, titre, description, duree, image_format, pays_origine, date_sortie, multilangage, date_publication)
    VALUES (1002, 1001, 2, 'Episode 2', 'Description 2', 60, '8k', 'France', SYSDATE - INTERVAL '10' DAY, 0, SYSDATE - INTERVAL '10' DAY );

    
    -- Insérer des abonnements
    INSERT INTO UserAbonnement (abo_id, user_id, emission_id) VALUES (1001, 1001, 1001);
    INSERT INTO UserAbonnement (abo_id, user_id, emission_id) VALUES (1002, 1001, 1002);
    --1001 s'abonne à 1001 et 1002 les Emission
    DBMS_OUTPUT.PUT_LINE('Données de test insérées.');

    -- Appeler la procédure pour insérer des suggestions
    DBMS_OUTPUT.PUT_LINE('Appel de la procédure suggest_new_episodes... qui va ajoute les suggestions dans la table');
    suggest_new_episodes(1001, 1000);
    --Utilisateur 1001 suggestion id 1000
    DBMS_OUTPUT.PUT_LINE('Procédure exécutée, les nouvelles suggestions : ');

    -- Vérifier les résultats
    DBMS_OUTPUT.PUT_LINE('Vérification des résultats...');
    FOR rec IN (SELECT * FROM VideoSuggestion WHERE user_id = 1001 ORDER BY suggestion_id) LOOP
        DBMS_OUTPUT.PUT_LINE('Suggestion ID: ' || rec.suggestion_id || ', Utilisateur ID: ' || rec.user_id || ', Video ID: ' || rec.video_id || ', Date Suggestion: ' || rec.date_creation);
    END LOOP;

    -- Nettoyer les données de test
    DBMS_OUTPUT.PUT_LINE('Nettoyage des données de test...');
    DELETE FROM VideoSuggestion WHERE user_id = 1001;
    DELETE FROM UserAbonnement WHERE user_id = 1001;
    DELETE FROM Video WHERE emission_id IN (1001, 1002);
    DELETE FROM Emission WHERE emission_id IN (1001, 1002); 
    DELETE FROM Utilisateur WHERE user_id = 1001;
    COMMIT;
    
    DELETE FROM VideosArchive;
    COMMIT;
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_archive_id';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_archive_id START WITH 1 NOCACHE INCREMENT BY 1';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Nettoyage des données de test effectué.');
END;
/
