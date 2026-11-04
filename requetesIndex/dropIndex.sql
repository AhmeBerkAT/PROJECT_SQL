BEGIN
    FOR rec IN (SELECT index_name FROM user_indexes WHERE index_name = 'IDX_HISTORIQUE_VIDEO_ID') LOOP
        EXECUTE IMMEDIATE 'DROP INDEX ' || rec.index_name;
    END LOOP;
    
    FOR rec IN (SELECT index_name FROM user_indexes WHERE index_name = 'IDX_HISTORIQUE_DATE_VISIONNEMENT') LOOP
        EXECUTE IMMEDIATE 'DROP INDEX ' || rec.index_name;
    END LOOP;
    
    FOR rec IN (SELECT index_name FROM user_indexes WHERE index_name = 'IDX_VIDEOS_EMISSION_ID') LOOP
        EXECUTE IMMEDIATE 'DROP INDEX ' || rec.index_name;
    END LOOP;
    
    FOR rec IN (SELECT index_name FROM user_indexes WHERE index_name = 'IDX_USER_ABONNEMENT_USER_ID') LOOP
        EXECUTE IMMEDIATE 'DROP INDEX ' || rec.index_name;
    END LOOP;
    
    FOR rec IN (SELECT index_name FROM user_indexes WHERE index_name = 'IDX_FAVORIS_USER_ID') LOOP
        EXECUTE IMMEDIATE 'DROP INDEX ' || rec.index_name;
    END LOOP;
    
    FOR rec IN (SELECT index_name FROM user_indexes WHERE index_name = 'IDX_HISTORIQUE_USER_ID') LOOP
        EXECUTE IMMEDIATE 'DROP INDEX ' || rec.index_name;
    END LOOP;
    
    FOR rec IN (SELECT index_name FROM user_indexes WHERE index_name = 'IDX_USERS_PAYS_ORIGINE') LOOP
        EXECUTE IMMEDIATE 'DROP INDEX ' || rec.index_name;
    END LOOP;
END;
/