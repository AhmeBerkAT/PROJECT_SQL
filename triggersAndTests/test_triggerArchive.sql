-- Enable DBMS_OUTPUT
SET SERVEROUTPUT ON;

BEGIN
    DELETE FROM VideosArchive;
    DBMS_OUTPUT.PUT_LINE('========== TEST TRIGGER ARCHIVE ===========');
    DBMS_OUTPUT.PUT_LINE('On vide la table videosArchive pour le test');
    -- Insert les Video de test
    INSERT INTO Video (video_id, emission_id, episode_num, titre, description, duree, date_sortie, multilangage, pays_origine, image_format, date_publication)
    VALUES (1000, 100, 1, 'Tester Episode', 'First episode of the series.', 45, TO_DATE('2023-01-01', 'YYYY-MM-DD'), 1, 'France', 'hd',CURRENT_TIMESTAMP - INTERVAL '10' DAY);
        
    DBMS_OUTPUT.PUT_LINE('Insertion video, video_id: 1000.');

    INSERT INTO Video (video_id, emission_id, episode_num, titre, description, duree, date_sortie, multilangage, pays_origine, image_format, date_publication)
    VALUES (1001, 100, 2, 'Test Episode', 'Second episode of the series.', 45, TO_DATE('2023-01-08', 'YYYY-MM-DD'), 1, 'France', 'hd',CURRENT_TIMESTAMP - INTERVAL '15' DAY);
    DBMS_OUTPUT.PUT_LINE('Insertion video, video_id: 1001.');

    -- Delete the first video from the Video table
    DELETE FROM Video WHERE video_id = 1000;
    DBMS_OUTPUT.PUT_LINE('Suppression de la video, video_id 1000 de la table Video');

    -- Delete the second video from the Video table
    DELETE FROM Video WHERE video_id = 1001;
    DBMS_OUTPUT.PUT_LINE('Suppression de la video, video_id 1001 de la table Video');
    
    -- Select and display the contents of the VideosArchive table
    DBMS_OUTPUT.PUT_LINE('Itere dans VideosArchive');
    FOR rec IN (SELECT * FROM VideosArchive) LOOP
        DBMS_OUTPUT.PUT_LINE('Archived video: ' || rec.archived_id || ','|| rec.video_id || ', ' || rec.titre || ', ' || rec.date_sortie);
    END LOOP;

    -- Clear the VideosArchive table and reset the sequence
    DELETE FROM VideosArchive;
    DBMS_OUTPUT.PUT_LINE('On vide la table videosArchive apres le test');

    -- Drop and recreate the sequence to reset it to 1
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_archive_id';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_archive_id START WITH 1 NOCACHE INCREMENT BY 1';
    DBMS_OUTPUT.PUT_LINE('et remet la sequence seq_archive_id a 1');
END;
/