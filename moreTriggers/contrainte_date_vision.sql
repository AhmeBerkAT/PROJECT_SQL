CREATE OR REPLACE TRIGGER trg_check_date_visionnement
BEFORE INSERT ON Historique
FOR EACH ROW
BEGIN
    -- Vérifie si la date d'insertion est après la date et l'heure actuelles (CURRENT_TIMESTAMP)
    IF :NEW.date_visionnement > CURRENT_TIMESTAMP THEN
        -- Si c'est le cas, remplace la date par la date et l'heure actuelles (CURRENT_TIMESTAMP)
        :NEW.date_visionnement := CURRENT_TIMESTAMP;
    END IF;
END;
/