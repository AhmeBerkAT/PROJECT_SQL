CREATE OR REPLACE PROCEDURE archive_old_videos IS
BEGIN
    -- Supprimer les vidéos publiées il y a 20 ans ou plus de la table originale
    DELETE FROM Video
    WHERE date_publication <= ADD_MONTHS(SYSDATE, -240);
    
    COMMIT;
END;
/




/*

BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'ARCHIVE_OLD_VIDEOS_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN archive_old_videos; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=MONTHLY; BYMONTHDAY=1; BYHOUR=0; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE
    );
END;
/

*/