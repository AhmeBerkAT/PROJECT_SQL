SET SERVEROUTPUT ON;

DECLARE
    v_date_visionnement TIMESTAMP;
    v_result_date TIMESTAMP;
BEGIN
    -- Date à insérer
    DBMS_OUTPUT.PUT_LINE('======= TEST DATE VISIONNEMENT =======');
    v_date_visionnement := TO_TIMESTAMP('2025-05-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS');
    DBMS_OUTPUT.PUT_LINE('Gestion contrainte dynamique de la table historique');
    DBMS_OUTPUT.PUT_LINE('Date à insérer, date invalide: ' || v_date_visionnement);

    -- Insérer dans Historique
    INSERT INTO Historique (historique_id, user_id, video_id, date_visionnement)
    VALUES (1001, 42, 15, v_date_visionnement);

    -- Récupérer la date résultante de Historique
    SELECT date_visionnement INTO v_result_date
    FROM Historique
    WHERE historique_id = 1001;

    DBMS_OUTPUT.PUT_LINE('Date résultante après le trigger : ' || v_result_date);

    -- Nettoyer les données de test
    DELETE FROM Historique WHERE historique_id = 1001;
    DBMS_OUTPUT.PUT_LINE('Nettoyage des données de test effectué');
END;
/