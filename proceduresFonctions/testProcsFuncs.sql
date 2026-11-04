SET SERVEROUTPUT ON;

DECLARE
    v_json_output CLOB;

-- 1. TESTER LA FONCTION video_to_json
BEGIN
        DBMS_OUTPUT.PUT_LINE('==========================');
    DBMS_OUTPUT.PUT_LINE('  DÉBUT DES TESTS DES PROCEDURES ET FONCTIONS');
    DBMS_OUTPUT.PUT_LINE('==========================');

    DBMS_OUTPUT.PUT_LINE('===== TEST : Fonction video_to_json =====');
    
    -- Tester la fonction avec un ID d'épisode valide

    BEGIN
        -- ID d'épisode existant
        v_json_output := video_to_json(1); -- Remplacez "1" par un ID valide de votre base
        DBMS_OUTPUT.PUT_LINE('JSON pour l''épisode 1 :');
        DBMS_OUTPUT.PUT_LINE(v_json_output);

        -- ID d'épisode existant
        v_json_output := video_to_json(200); -- Remplacez "2" par un autre ID valide
        DBMS_OUTPUT.PUT_LINE('JSON pour l''épisode 2 :');
        DBMS_OUTPUT.PUT_LINE(v_json_output);

        -- Tester avec un ID inexistant
        v_json_output := video_to_json(9599); -- ID d'épisode inexistant
        DBMS_OUTPUT.PUT_LINE('JSON pour un épisode inexistant :');
        DBMS_OUTPUT.PUT_LINE(v_json_output);
    END;
END;
/

-- 2. TESTER LA PROCÉDURE generate_newsletter_text
BEGIN
    DBMS_OUTPUT.PUT_LINE('===== TEST : Procédure generate_newsletter_text =====');
    
    -- Tester la génération de la newsletter pour afficher les sorties récentes
    DBMS_OUTPUT.PUT_LINE('Sorties récentes :');
    generate_newsletter_text;
END;
/
-- 3. TESTER LA PROCÉDURE generate_recommendations
BEGIN
    DBMS_OUTPUT.PUT_LINE('===== TEST : Procédure generate_recommendations =====');
    
    -- Tester les recommandations pour un utilisateur avec des préférences
    DBMS_OUTPUT.PUT_LINE('Recommandations pour l''utilisateur 1, abonné a kdrama et horror :');
    generate_recommendations(1); -- Remplacez "1" par un ID utilisateur valide

    -- Tester les recommandations pour un utilisateur sans préférences
    DBMS_OUTPUT.PUT_LINE('Recommandations pour un utilisateur sans préférences :');
    generate_recommendations(2); -- Remplacez "2" par un ID utilisateur sans préférences (si possible)
    DBMS_OUTPUT.PUT_LINE('(Exception)Recommandations pour un utilisateur qui n existe pas :');
    generate_recommendations(45023);
END;
/