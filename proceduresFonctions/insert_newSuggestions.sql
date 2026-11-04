CREATE OR REPLACE PROCEDURE suggest_new_episodes (
    p_user_id INT,
    p_suggestion_id INT
) IS
BEGIN
    -- Insérer les nouveaux épisodes des émissions auxquelles l'utilisateur est abonné
    INSERT INTO VideoSuggestion (suggestion_id, user_id, video_id)
    SELECT 
        p_suggestion_id + ROW_NUMBER() OVER (ORDER BY v.video_id), -- Générer des IDs uniques pour les suggestions
        ua.user_id,
        v.video_id
    FROM 
        UserAbonnement ua
    JOIN 
        Video v ON ua.emission_id = v.emission_id
    LEFT JOIN 
        VideoSuggestion vs ON ua.user_id = vs.user_id AND v.video_id = vs.video_id
    WHERE 
        ua.user_id = p_user_id
        AND v.date_sortie >= SYSDATE - INTERVAL '30' DAY -- Considérer les épisodes sortis au cours des 30 derniers jours
        AND vs.video_id IS NULL; -- Éviter les doublons dans les suggestions

    COMMIT;
END;
/
