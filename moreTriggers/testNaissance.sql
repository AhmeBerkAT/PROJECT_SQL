SET SERVEROUTPUT ON;

BEGIN
    -- Insérer des données de test valides
    DBMS_OUTPUT.PUT_LINE('======= TEST DATE DE NAISSANCE =======');
    DBMS_OUTPUT.PUT_LINE('Insertion des données de test valides... user a 10 ans');
    BEGIN
        INSERT INTO Utilisateur (user_id, login, mdp, prenom, nom, email, date_naissance, abo_newsletter, pays_origine)
        VALUES (1000, 'user1000', 'password1000', 'Prenom1000', 'Nom1000', 'user1000@example.com', ADD_MONTHS(SYSDATE, -12*10), 0, 'France');
        DBMS_OUTPUT.PUT_LINE('Utilisateur 1000 inséré avec succès.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur lors de l insertion de l utilisateur 1000 : ' || SQLERRM);
    END;

    -- Insérer des données de test invalides
    DBMS_OUTPUT.PUT_LINE('Insertion des données de test invalides... user a moins de 2 ans');
    BEGIN
        INSERT INTO Utilisateur (user_id, login, mdp, prenom, nom, email, date_naissance, abo_newsletter, pays_origine)
        VALUES (1001, 'user1001', 'password1001', 'Prenom1001', 'Nom1001', 'user1001@example.com', ADD_MONTHS(SYSDATE, -12*2 + 1), 0, 'France');
        DBMS_OUTPUT.PUT_LINE('Utilisateur 1001 inséré avec succès.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur lors de l insertion de l utilisateur 1001 : ' || SQLERRM);
    END;

    -- Nettoyer les données de test
    DBMS_OUTPUT.PUT_LINE('Nettoyage des données de test...');
    DELETE FROM Utilisateur WHERE user_id IN (1000, 1001);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Nettoyage des données de test effectué.');
END;
/