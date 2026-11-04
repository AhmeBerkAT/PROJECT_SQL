-- Create the trigger to limit viewings per minute
CREATE OR REPLACE TRIGGER limit_visionnage_par_minute
BEFORE INSERT ON Historique
FOR EACH ROW
DECLARE
    viewing_count INT;
BEGIN
    -- Count the number of viewings by the same Utilisateur in the last minute
    SELECT COUNT(*)
    INTO viewing_count
    FROM Historique
    WHERE user_id = :NEW.user_id
    AND date_visionnement > (CURRENT_TIMESTAMP - INTERVAL '1' MINUTE);

    -- If the count is 3 or more, raise an error
    IF viewing_count >= 3 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Attention limite de 3 Video par minute atteint');
    END IF;
END;
/

