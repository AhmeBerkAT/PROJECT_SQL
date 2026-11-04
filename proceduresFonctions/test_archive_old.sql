SET SERVEROUTPUT ON;

BEGIN
    DELETE Video where video_id between 10001 and 10005;
    DELETE videosArchive;
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_archive_id';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_archive_id START WITH 1 NOCACHE INCREMENT BY 1';
    DBMS_OUTPUT.PUT_LINE('======= TEST PROCEDURE D ARCHIVAGE DES VIDEOS PUBLIES IL Y A 20 ANS =======');
    -- Insérer des vidéos avec différentes dates de publication
    DBMS_OUTPUT.PUT_LINE('Insertion des vidéos de test 10001 à 10005..., avec date de publication de 1997,1998.1999.2023.2024... respectivement.');
    INSERT INTO Video (video_id, emission_id, episode_num, titre, description, duree, image_format, pays_origine, date_sortie, multilangage, date_publication)
    VALUES (10001, 1, 1, 'Video 1', 'Description de la vidéo 1', 120, '8k', 'France', TO_DATE('1997-01-01', 'YYYY-MM-DD'), 0, TO_TIMESTAMP('1997-01-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    
    INSERT INTO Video (video_id, emission_id, episode_num, titre, description, duree, image_format, pays_origine, date_sortie, multilangage, date_publication)
    VALUES (10002, 1, 2, 'Video 2', 'Description de la vidéo 2', 120, '8k', 'France', TO_DATE('1998-01-01', 'YYYY-MM-DD'), 0, TO_TIMESTAMP('1998-01-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));

    INSERT INTO Video (video_id, emission_id, episode_num, titre, description, duree, image_format, pays_origine, date_sortie, multilangage, date_publication)
    VALUES (10003, 1, 3, 'Video 3', 'Description de la vidéo 3', 120, '8k', 'France', TO_DATE('1999-01-01', 'YYYY-MM-DD'), 0, TO_TIMESTAMP('1999-01-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));

    INSERT INTO Video (video_id, emission_id, episode_num, titre, description, duree, image_format, pays_origine, date_sortie, multilangage, date_publication)
    VALUES (10004, 1, 4, 'Video 4', 'Description de la vidéo 4', 120, '8k', 'France', TO_DATE('2023-01-01', 'YYYY-MM-DD'), 0, TO_TIMESTAMP('2023-01-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));

    INSERT INTO Video (video_id, emission_id, episode_num, titre, description, duree, image_format, pays_origine, date_sortie, multilangage, date_publication)
    VALUES (10005, 1, 5, 'Video 5', 'Description de la vidéo 5', 120, '8k', 'France', TO_DATE('2024-01-01', 'YYYY-MM-DD'), 0, TO_TIMESTAMP('2024-01-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));

    DBMS_OUTPUT.PUT_LINE('Insertion des vidéos de test terminée.');

    -- Appeler la procédure d'archivage
    DBMS_OUTPUT.PUT_LINE('Appel de la procédure d archivage...');
    archive_old_videos;
    DBMS_OUTPUT.PUT_LINE('Procédure d archivage terminée.');

    -- Afficher les vidéos archivées
    DBMS_OUTPUT.PUT_LINE('Vidéos archivées :');
    FOR rec IN (SELECT * FROM VideosArchive ORDER BY archived_id) LOOP
        DBMS_OUTPUT.PUT_LINE('Archived ID: ' || rec.archived_id || ', Video ID: ' || rec.video_id || ', Titre: ' || rec.titre || ', Date de publication: ' || rec.date_publication);
    END LOOP;

    -- Afficher les vidéos restantes dans la table originale
    DBMS_OUTPUT.PUT_LINE('Vidéos restantes dans la table originale :');
    FOR rec IN (SELECT * FROM Video WHERE video_id BETWEEN 10000 AND 10005 ORDER BY video_id) LOOP
        DBMS_OUTPUT.PUT_LINE('Video ID: ' || rec.video_id || ', Titre: ' || rec.titre || ', Date de publication: ' || rec.date_publication);
    END LOOP;

    -- Nettoyer les données de test
    DBMS_OUTPUT.PUT_LINE('Nettoyage des données de test...');
    DELETE FROM VideosArchive WHERE video_id >= 10000;
    DELETE FROM Video WHERE video_id >= 10001;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Nettoyage des données de test effectué.');

    -- Réinitialiser la séquence
    DBMS_OUTPUT.PUT_LINE('Réinitialisation de la séquence seq_archive_id...');
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_archive_id';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_archive_id START WITH 1 NOCACHE INCREMENT BY 1';
    DBMS_OUTPUT.PUT_LINE('Séquence seq_archive_id réinitialisée.');
END;
/