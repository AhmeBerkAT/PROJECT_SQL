CREATE OR REPLACE TRIGGER trg_check_date_publication
BEFORE INSERT OR UPDATE ON Video
FOR EACH ROW
BEGIN
    IF TRUNC(:NEW.date_publication) < TRUNC(:NEW.date_sortie) THEN
        RAISE_APPLICATION_ERROR(-20020, 'La date de publication doit être après la date de sortie.');
    END IF;
END;
/