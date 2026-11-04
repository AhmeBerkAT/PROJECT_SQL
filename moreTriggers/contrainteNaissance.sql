CREATE OR REPLACE TRIGGER trg_check_date_naissance
BEFORE INSERT OR UPDATE ON Utilisateur
FOR EACH ROW
BEGIN
    IF :NEW.date_naissance > ADD_MONTHS(SYSDATE, -12*2) THEN
        RAISE_APPLICATION_ERROR(-20031, 'La date de naissance doit être au moins de 2 ans avant la date actuelle.');
    END IF;
END;
/
