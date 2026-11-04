SET SERVEROUTPUT ON;

BEGIN
    -- Insérer des données de test valides
    DBMS_OUTPUT.PUT_LINE('======= TEST CONTRAINTE PUBLICATION =======');
    DBMS_OUTPUT.PUT_LINE('Insertion des données de test valides...');
    BEGIN
        INSERT INTO Video (video_id, emission_id, episode_num, titre, description, duree, image_format, pays_origine, date_sortie, multilangage, date_publication)
        VALUES (1000, 1, 1, 'Episode 1', 'Description 1', 60, 'hd', 'France', SYSDATE - INTERVAL '15' DAY, 0, SYSDATE - INTERVAL '10' DAY);
        DBMS_OUTPUT.PUT_LINE('Vidéo 1 insérée avec succès.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur lors de l insertion de la vidéo 1 : ' || SQLERRM);
    END;

    -- Insérer des données de test invalides
    DBMS_OUTPUT.PUT_LINE('Insertion des données de test invalides... date de sortie il y a 5 jours, date de publication il y a 10 jours');
    BEGIN
        INSERT INTO Video (video_id, emission_id, episode_num, titre, description, duree, image_format, pays_origine, date_sortie, multilangage, date_publication)
        VALUES (1001, 1, 2, 'Episode 2', 'Description 2', 60, 'hd', 'France', SYSDATE - INTERVAL '5' DAY, 0, SYSDATE - INTERVAL '10' DAY);
        DBMS_OUTPUT.PUT_LINE('Vidéo 2 insérée avec succès.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur lors de l insertion de la vidéo 2 : ' || SQLERRM);
    END;

    -- Nettoyer les données de test
    DBMS_OUTPUT.PUT_LINE('Nettoyage des données de test...');
    DELETE FROM Video WHERE video_id IN (1000, 1001);
    COMMIT;
    DELETE FROM VideosArchive;
    COMMIT;
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_archive_id';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_archive_id START WITH 1 NOCACHE INCREMENT BY 1';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Nettoyage des données de test effectué.');
END;
/