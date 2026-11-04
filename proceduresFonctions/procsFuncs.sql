CREATE OR REPLACE FUNCTION video_to_json(p_video_id INT) RETURN CLOB IS
    v_json CLOB;
BEGIN
    SELECT JSON_OBJECT(
        'video_id' VALUE video_id,
        'titre' VALUE titre,
        'description' VALUE description,
        'duree' VALUE duree,
        'pays_origine' VALUE pays_origine,
        'date_sortie' VALUE TO_CHAR(date_sortie, 'YYYY-MM-DD'),
        'multilangage' VALUE multilangage
    ) INTO v_json
    FROM Video
    WHERE video_id = p_video_id;

    RETURN v_json;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '{"error": "Video not found"}';
END;
/


CREATE OR REPLACE PROCEDURE generate_newsletter_text IS
    v_newsletter CLOB;
BEGIN
    v_newsletter := 'Bonjour, voici les nouvelles sorties de cette semaine : ' || CHR(10);

    FOR rec IN (
        SELECT titre, date_sortie
        FROM Video
        WHERE date_sortie BETWEEN SYSDATE - 7 AND SYSDATE --ICI ON PEUT CHANGER LA DATE 
        ORDER BY date_sortie DESC
    ) LOOP
        v_newsletter := v_newsletter || '- ' || rec.titre || ' (Sortie : ' || TO_CHAR(rec.date_sortie, 'DD-MM-YYYY') || ')' || CHR(10);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(v_newsletter);
END;
/
CREATE OR REPLACE PROCEDURE generate_recommendations(p_user_id INT) IS
    v_recommendations CLOB := '';  -- Initialize as empty CLOB
    v_count INT := 0;  -- Variable to count the number of recommendations    
    user_not_found EXCEPTION; -- Exception for Utilisateur not found
BEGIN
    -- Check if the Utilisateur exists in Utilisateur table
    SELECT COUNT(*) INTO v_count
    FROM Utilisateur
    WHERE user_id = p_user_id;

    -- Raise an exception if the Utilisateur does not exist
    IF v_count = 0 THEN
        RAISE user_not_found;
    END IF;

    -- Generate recommendations if Utilisateur exists
    v_recommendations := '===================================' || CHR(10) ||
                         'Bonjour, voici les vidéos conseillées pour vous :' || CHR(10) ||
                         '===================================' || CHR(10);

    -- Reset counter for recommendations
    v_count := 0;

    -- Fetch recommendations based on the popularity of Video in the Utilisateur's preferred Categorie
    FOR rec IN (
        SELECT e.titre, e.description, e.date_sortie, s.nom_categorie, COUNT(vh.historique_id) AS view_count
        FROM Video e
        JOIN Emission s ON e.emission_id = s.emission_id
        JOIN Historique vh ON e.video_id = vh.video_id
        JOIN UserPreference up ON up.nom_categorie = s.nom_categorie
        WHERE up.user_id = p_user_id
        AND vh.date_visionnement >= SYSDATE - 14 -- CHANGER LA DATE POUR LA POPULARITE COMME VOUS VOULEZ
        GROUP BY e.titre, e.description, e.date_sortie, s.nom_categorie
        ORDER BY view_count DESC, e.date_sortie DESC
    ) LOOP
        v_recommendations := v_recommendations || '- ' || rec.titre || 
                             ' (Sortie : ' || TO_CHAR(rec.date_sortie, 'DD-MM-YYYY') || 
                             ', Catégorie : ' || rec.nom_categorie || 
                             ', Popularité 2 semaines: ' || rec.view_count || ')' || CHR(10);
        v_count := v_count + 1;
    END LOOP;

    -- If no recommendations were found, add a message saying no recent viewings or preferences
    IF v_count = 0 THEN
        v_recommendations := v_recommendations || 'Aucune catégorie suivie ou pas de video populaire.' || CHR(10);
    END IF;

    v_recommendations := v_recommendations || '===================================' || CHR(10);

    -- Display recommendations
    DBMS_OUTPUT.PUT_LINE(v_recommendations);

EXCEPTION
    WHEN user_not_found THEN
        DBMS_OUTPUT.PUT_LINE('Aucun utilisateur trouvé avec l''ID : ' || p_user_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Une erreur s''est produite : ' || SQLERRM);
END;
/