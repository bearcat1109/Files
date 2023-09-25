-- Authored 9/15/2023 by Gabriel Berres. VIP List puller v1
-- v2 - added Dr. prefix to anyone with SPBPERS_NAME_PREFIX of Dr. or Dr
-- v3 - added extension filtering to have President at the top
WITH w_nbrjobs AS (
    SELECT DISTINCT
        nbrjobs_pidm                    w_nbrjobs_pidm,
        MAX(nbrjobs_effective_date)
        OVER(PARTITION BY nbrjobs_pidm) w_nbrjobs_effective_date
    FROM
        nbrjobs
)
select distinct
    CASE
        WHEN spbpers_name_prefix LIKE 'Dr%'
            THEN 'Dr. ' || (spriden_first_name || ' ' || spriden_last_name)
        ELSE
            spriden_first_name || ' ' || spriden_last_name
        END AS Name,
    gobtpac_external_user Username,
        --nsu_directory.directory_location.extension Extension,
    CASE
        WHEN LENGTH(nsu_directory.directory_location.extension) = 4
            THEN nsu_directory.directory_location.extension
    END AS Extension,
    CASE
        WHEN LENGTH(nsu_directory.directory_location.extension) != 4
            THEN nsu_directory.directory_location.extension
    END AS Full_Or_Alt_Number,
    nbrjobs_desc Job_Title
from
         spriden
    JOIN nsu_directory.directory_location ON spriden_pidm = nsu_directory.directory_location.pidm
    JOIN gobtpac on spriden_pidm = gobtpac_pidm
    JOIN spbpers on spriden_pidm = spbpers_pidm
    JOIN w_nbrjobs ON w_nbrjobs_pidm = spriden_pidm
    JOIN nbrjobs ON w_nbrjobs_pidm = nbrjobs_pidm
                    AND w_nbrjobs_effective_date = nbrjobs_effective_date
WHERE
     (
        nbrjobs_desc LIKE '%President%'
        OR
        nbrjobs_desc LIKE '%Director%'
        OR
        nbrjobs_desc LIKE '%Dean%'
        OR
        nbrjobs_desc LIKE '%Chair%'
        OR
        nbrjobs_desc LIKE '%Provost%'
        OR
        nbrjobs_desc LIKE '%Coordinator%'
        OR
        nbrjobs_desc LIKE '%Associate%'
        OR
        nbrjobs_desc LIKE '%Registrar%'
        OR
        nbrjobs_desc LIKE '%Payroll Team Leader%'
        OR
        nbrjobs_desc LIKE '%General Counsel%'
        OR
        nbrjobs_desc LIKE '%Manager%'
        OR
        nbrjobs_desc LIKE '%Administrative Assistant%'
     )
    AND spriden_change_ind IS NULL
    AND spriden_entity_ind = 'P'
ORDER BY
    Extension ASC
