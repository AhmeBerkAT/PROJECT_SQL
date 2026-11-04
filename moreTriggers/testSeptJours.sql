SET SERVEROUTPUT ON;

BEGIN
    -- Insérer des vidéos avec différentes dates de publication
    DBMS_OUTPUT.PUT_LINE('======= TEST SEPT JOURS =======');
    DBMS_OUTPUT.PUT_LINE('Insertion des vidéos de test...');
    INSERT INTO Video (video_id, emission_id, episode_num, titre, description, duree, image_format, pays_origine, date_sortie, multilangage, date_publication)
    VALUES (10001, 1, 1, 'Video 1', 'Description de la vidéo 1', 120, '8k', 'France', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 0, CURRENT_TIMESTAMP - INTERVAL '8' DAY);

    INSERT INTO Video (video_id, emission_id, episode_num, titre, description, duree, image_format, pays_origine, date_sortie, multilangage, date_publication)
    VALUES (10002, 1, 2, 'Video 2', 'Description de la vidéo 2', 120, '8k', 'France', TO_DATE('2021-01-01', 'YYYY-MM-DD'), 0, CURRENT_TIMESTAMP - INTERVAL '6' DAY);

    DBMS_OUTPUT.PUT_LINE('Insertion des vidéos de test terminée.');

    -- Essayer de supprimer une vidéo publiée il y a plus de 7 jours
    DBMS_OUTPUT.PUT_LINE('Suppression de la vidéo 10001...');
    DELETE FROM Video WHERE video_id = 10001;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Vidéo 10001 supprimée sans probleme.');

    -- Essayer de supprimer une vidéo publiée il y a moins de 7 jours
    DBMS_OUTPUT.PUT_LINE('Suppression de la vidéo 10002...');
    BEGIN
        DELETE FROM Video WHERE video_id = 10002;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
    END;

    -- Nettoyer les données de test
    DBMS_OUTPUT.PUT_LINE('Mettre à jour la date de publication pour permettre la suppression, nettoyage des données de test...');
    UPDATE Video SET date_publication = CURRENT_TIMESTAMP - INTERVAL '8' DAY WHERE video_id = 10002;
    COMMIT;
    DELETE FROM Video WHERE video_id = 10002;
    COMMIT;
    DELETE FROM VideosArchive;
    COMMIT;
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_archive_id';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_archive_id START WITH 1 NOCACHE INCREMENT BY 1';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Nettoyage des données de test effectué.');
END;
/