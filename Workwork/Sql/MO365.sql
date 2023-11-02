-- New MicrosoftOffice365 report, written 11-2-2023 Gabriel Berres

SELECT DISTINCT 
    spriden_first_name FIRSTNAME,
    spriden_last_name LASTNAME,
    spriden_mi SPRIDEN_MI,
    spriden_first_name || ' ' || spriden_mi || ' ' || spriden_last_name  DISPLAYNAME,
    gobtpac_external_user || '@nsuok.edu' NSU_EMAIL,
    gobtpac_external_user NSU_USERID,
    gobumap_udc_id IMMUTABLEID
FROM 
    spriden
    LEFT JOIN gobtpac on gobtpac_pidm = spriden_pidm
    LEFT JOIN gobumap on gobumap_pidm = spriden_pidm
    LEFT JOIN pebempl on pebempl_pidm = spriden_pidm
    LEFT JOIN sfrstcr on sfrstcr_pidm = spriden_pidm
        AND sfrstcr_rsts_code IN ('RE', 'RW', 'RF', 'RA', 'AU')
WHERE
    (
        pebempl_empl_status != 'T'
        AND pebempl_ecls_code NOT IN ('90', '92', '99')
    ) OR 
    (
        sfrstcr_rsts_code IN ('RE', 'RW', 'RF', 'RA', 'AU')
        AND (sfrstcr_term_code IN
        (
            SELECT 
                stvterm_code
            FROM 
                stvterm
            WHERE
                stvterm_code >= (
                SELECT MAX(stvterm_code)
                FROM 
                    stvterm
                WHERE 
                    sysdate < stvterm_end_date
                AND sysdate > stvterm_start_date
                AND stvterm_code NOT LIKE '%9'))
            )
    ) 
    OR sfrstcr_rsts_date > sysdate - 60
    AND spriden_entity_ind = 'P'
;

    
