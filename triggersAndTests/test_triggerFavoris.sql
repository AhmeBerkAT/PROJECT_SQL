SET SERVEROUTPUT ON;

-- Insert 300 Favoris for the test Utilisateur starting from favoris_id 301
DECLARE
    i INT;
    j INT := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('=== TEST TRIGGER FAVORIS (LIMITE 300) ====');
    DBMS_OUTPUT.PUT_LINE('insertion 300 favoris pour l Utilisateur 1000====');

    -- Insert a test Utilisateur
    INSERT INTO Utilisateur (user_id, login, mdp, prenom, nom, email, date_naissance, abo_newsletter, pays_origine) 
    VALUES (1000, 'test_user1', 'testpassword1', 'Test1', 'User1', 'test1.Utilisateur@example.com', TO_DATE('2003-08-01', 'YYYY-MM-DD'), 1, 'Testland');

    FOR i IN 1001..1300 LOOP
        INSERT INTO Favoris (favoris_id, user_id, video_id) VALUES (i, 1000, j);
        j := j + 1;

    END LOOP;
    DBMS_OUTPUT.PUT_LINE('==Apres l ajout de 300 favoris pour l Utilisateur 1000==');
    DBMS_OUTPUT.PUT_LINE('==========================================================');
    DBMS_OUTPUT.PUT_LINE('==On essaie d ajouter le 301eme favoris pour l Utilisateur 1000==');
    INSERT INTO Favoris (favoris_id, user_id, video_id) VALUES (1301, 1000, 301);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);

DELETE FROM Favoris WHERE user_id = 1000;
DELETE FROM Utilisateur WHERE user_id = 1000;
--test data supression
END;
/