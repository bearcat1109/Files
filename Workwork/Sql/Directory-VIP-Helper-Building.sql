-- Written 9/14/2023 by Gabriel Berres. Pull all employees,
-- names, extensions, offices, and positions.
WITH w_nbrjobs AS (
    SELECT DISTINCT
        nbrjobs_pidm                    w_nbrjobs_pidm,
        MAX(nbrjobs_effective_date)
        OVER(PARTITION BY nbrjobs_pidm) w_nbrjobs_effective_date
    FROM
        nbrjobs
)
SELECT DISTINCT
    CASE
        WHEN spbpers_name_prefix LIKE 'Dr%'
            THEN 'Dr. ' || (spriden_first_name || ' ' || spriden_last_name)
        ELSE
            spriden_first_name || ' ' || spriden_last_name
    END AS Name,
    nbrjobs_desc                               AS Job,
    CASE
        WHEN LENGTH(nsu_directory.directory_location.extension) = 4
            THEN nsu_directory.directory_location.extension
    END AS Extension,
    CASE
        WHEN LENGTH(nsu_directory.directory_location.extension) != 4
            THEN nsu_directory.directory_location.extension
    END AS Full_Or_Alt_Number,
    gobtpac_external_user Username,
    nsu_directory.directory_location.campus    AS Campus,
    nsu_directory.directory_location.building  AS Building,
    nsu_directory.directory_location.office    AS Office
FROM
         spriden
    JOIN nsu_directory.directory_location ON spriden_pidm = nsu_directory.directory_location.pidm
    JOIN spbpers on spriden_pidm = spbpers_pidm
    JOIN gobtpac on spriden_pidm = gobtpac_pidm
    JOIN pebempl on spriden_pidm = pebempl_pidm
    JOIN w_nbrjobs ON w_nbrjobs_pidm = spriden_pidm
    JOIN nbrjobs ON w_nbrjobs_pidm = nbrjobs_pidm
                    AND w_nbrjobs_effective_date = nbrjobs_effective_date
WHERE
    nsu_directory.directory_location.building = :Edit2
    AND spriden_change_ind IS NULL
    AND spriden_entity_ind = 'P'
    AND pebempl_empl_status = 'A'
    AND :btnGo3 = 1
ORDER BY
    Extension ASC
