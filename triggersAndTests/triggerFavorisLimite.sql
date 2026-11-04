CREATE OR REPLACE TRIGGER check_favorites_limit
BEFORE INSERT OR UPDATE ON Favoris
FOR EACH ROW
DECLARE
    favorite_count INT;
BEGIN
    SELECT COUNT(*)
    INTO favorite_count
    FROM Favoris
    WHERE user_id = :NEW.user_id;

    IF favorite_count >= 300 THEN
        RAISE_APPLICATION_ERROR(-20011, 'ATTENTION limite de 300 Video favoris atteint');
    END IF;
END;
/