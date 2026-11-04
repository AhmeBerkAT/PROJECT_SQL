DROP SEQUENCE seq_archive_id;
CREATE SEQUENCE seq_archive_id
START WITH 1
nocache
INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_archived_id
BEFORE INSERT ON VideosArchive
FOR EACH ROW
BEGIN
    :NEW.archived_id := seq_archive_id.NEXTVAL;
END;
/

-- Création ou remplacement de la fonction d'archivage
CREATE OR REPLACE TRIGGER trg_archive_video
AFTER DELETE ON Video
FOR EACH ROW
BEGIN
    -- Insérer la vidéo supprimée dans la table d'archivage
INSERT INTO VideosArchive (video_id, emission_id, episode_num, titre, 
description, duree, date_sortie, date_archivage, multilangage, image_format, pays_origine, date_publication)

VALUES (:OLD.video_id, :OLD.emission_id,
:OLD.episode_num, :OLD.titre,
:OLD.description,
:OLD.duree,
:OLD.date_sortie, 
CURRENT_TIMESTAMP,
:OLD.multilangage,
:OLD.image_format,
:OLD.pays_origine,
:OLD.date_publication);
END;
/


