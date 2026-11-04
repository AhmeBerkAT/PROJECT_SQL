SET SERVEROUTPUT ON;


BEGIN
    
    DBMS_OUTPUT.PUT_LINE('========== TEST TRIGGER SPAM ===========');
    INSERT INTO Historique (historique_id, user_id, video_id, date_visionnement)
    VALUES (1001, 42, 15, CURRENT_TIMESTAMP);
    DBMS_OUTPUT.PUT_LINE('Utilisateur 42 regarde 1 video');

    
    INSERT INTO Historique (historique_id, user_id, video_id, date_visionnement)
    VALUES (1002, 42, 41, CURRENT_TIMESTAMP);
    DBMS_OUTPUT.PUT_LINE('Utilisateur 42 regarde 2 Video');

    
    INSERT INTO Historique (historique_id, user_id, video_id, date_visionnement)
    VALUES (1003, 42, 10, CURRENT_TIMESTAMP);
    DBMS_OUTPUT.PUT_LINE('Utilisateur 42 regarde 3 Video');

    --ici on s attend a un trigger avec 4 Video
    INSERT INTO Historique (historique_id, user_id, video_id, date_visionnement)
    VALUES (1004, 42, 15, CURRENT_TIMESTAMP);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    
    DBMS_OUTPUT.PUT_LINE('Supression des donnees de test');
    DELETE FROM Historique WHERE historique_id IN (1001, 1002, 1003);
    DBMS_OUTPUT.PUT_LINE('Cleaned up test data');
END;
/