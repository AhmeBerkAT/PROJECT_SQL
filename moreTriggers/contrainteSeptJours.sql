CREATE OR REPLACE TRIGGER triggerSeptJours
BEFORE DELETE ON Video
FOR EACH ROW
BEGIN
    -- Vérifie si la date de publication est inférieure à 7 jours
    IF :OLD.date_publication > (CURRENT_TIMESTAMP - INTERVAL '7' DAY) THEN
        -- Empêche la suppression de la vidéo
        RAISE_APPLICATION_ERROR(-20014, 'ATTENTION: la vidéo ne peut pas être supprimée car elle a été publiée il y a moins de 7 jours.');
    END IF;
END;
/
