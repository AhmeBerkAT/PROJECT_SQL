CREATE INDEX idx_historique_video_id ON Historique(video_id);
CREATE INDEX idx_historique_date_visionnement ON Historique(date_visionnement);
CREATE INDEX idx_videos_emission_id ON Video(emission_id);
CREATE INDEX idx_user_abonnement_user_id ON UserAbonnement(user_id);
CREATE INDEX idx_favoris_user_id ON Favoris(user_id);
CREATE INDEX idx_historique_user_id ON Historique(user_id);
CREATE INDEX idx_users_pays_origine ON Utilisateur(pays_origine);

--1
SELECT s.nom_categorie, COUNT(vh.video_id) AS nb_visionnages_en2semaines 
FROM Historique vh
JOIN Video e ON vh.video_id = e.video_id
JOIN Emission s ON e.emission_id = s.emission_id
WHERE vh.date_visionnement >= SYSDATE - 14
GROUP BY s.nom_categorie
ORDER BY nb_visionnages_en2semaines DESC;

--2
SELECT 
    u.user_id,
    u.login,
    COUNT(DISTINCT us.abo_id) AS nombre_abonnement,
    COUNT(DISTINCT f.favoris_id) AS nombre_favoris,
    COUNT(DISTINCT vh.historique_id) AS videos_regardes
FROM 
    Utilisateur u
LEFT JOIN 
    UserAbonnement us ON u.user_id = us.user_id
LEFT JOIN 
    Favoris f ON u.user_id = f.user_id
LEFT JOIN 
    Historique vh ON u.user_id = vh.user_id
GROUP BY 
    u.user_id, u.login
ORDER BY 
    u.user_id;
--3
SELECT 
    v.video_id,
    v.titre,
    COUNT(CASE WHEN u.pays_origine = 'France' THEN vh.historique_id END) AS visionnage_francais,
    COUNT(CASE WHEN u.pays_origine = 'Germany' THEN vh.historique_id END) AS visionnage_allemand,
    ABS(COUNT(CASE WHEN u.pays_origine = 'France' THEN vh.historique_id END) - COUNT(CASE WHEN u.pays_origine = 'Germany' THEN vh.historique_id END)) AS difference
FROM 
    Video v
LEFT JOIN 
    Historique vh ON v.video_id = vh.video_id
LEFT JOIN 
    Utilisateur u ON vh.user_id = u.user_id
GROUP BY 
    v.video_id, v.titre
ORDER BY 
    difference DESC;

--J'ai 408 vidéos au totale parce que j'en ai ajouté quelques-uns pour que je puisse mieux vérifier certaines requetes 
--et pour avoir des données plus variées

--4
SELECT e.video_id, e.titre, e.emission_id, COUNT(vh.video_id) AS nb_visionnages
FROM Historique vh
JOIN Video e ON vh.video_id = e.video_id
GROUP BY e.video_id, e.titre, e.emission_id
HAVING COUNT(vh.video_id) >= 2 * (
    SELECT AVG(view_count)
    FROM (
        SELECT COUNT(vh2.video_id) AS view_count
        FROM Historique vh2
        JOIN Video e2 ON vh2.video_id = e2.video_id
        WHERE e2.emission_id = e.emission_id
        GROUP BY e2.video_id
    )
);

--5
SELECT 
    LEAST(vh1.video_id, vh2.video_id) AS video_id_1,
    GREATEST(vh1.video_id, vh2.video_id) AS video_id_2,
    COUNT(DISTINCT vh1.user_id) AS compte_paire
FROM 
    (SELECT DISTINCT user_id, video_id FROM Historique) vh1
JOIN 
    (SELECT DISTINCT user_id, video_id FROM Historique) vh2
ON 
    vh1.user_id = vh2.user_id 
    AND vh1.video_id < vh2.video_id
GROUP BY 
    LEAST(vh1.video_id, vh2.video_id),
    GREATEST(vh1.video_id, vh2.video_id)
ORDER BY 
    compte_paire DESC
FETCH FIRST 10 ROWS ONLY;
 