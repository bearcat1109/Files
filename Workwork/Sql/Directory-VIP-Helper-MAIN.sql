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
    spriden_last_name                          AS LastName,
    spriden_first_name                         AS FirstName,
    nbrjobs_desc                               AS Job,
    nsu_directory.directory_location.extension AS Extension,
    nsu_directory.directory_location.campus    AS Campus,
    nsu_directory.directory_location.building  AS Building,
    nsu_directory.directory_location.office    AS Office
FROM
         spriden
    JOIN nsu_directory.directory_location ON spriden_pidm = nsu_directory.directory_location.pidm
    JOIN w_nbrjobs ON w_nbrjobs_pidm = spriden_pidm
    JOIN nbrjobs ON w_nbrjobs_pidm = nbrjobs_pidm
                    AND w_nbrjobs_effective_date = nbrjobs_effective_date
WHERE
     (
      (UPPER(spriden_last_name) LIKE ('%' || UPPER(:Edit1) || '%'))
      OR
      (UPPER(spriden_first_name) LIKE ('%' || UPPER(:Edit1) || '%'))
      OR
      (spriden_id = UPPER(:Edit1))
      OR
      (UPPER(nbrjobs_desc) LIKE ('%' || UPPER(:Edit1) || '%'))
     )
    --AND spriden_change_ind IS NULL
    --AND spriden_entity_ind = 'P'
    AND :btnGo = 1
ORDER BY
    LastName
