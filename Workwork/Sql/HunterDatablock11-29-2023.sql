-- Written 11-29-2023. Pulls Employee last name, first name, N#, and
-- username. Made for Hunter.

WITH w_spriden AS
(
     SELECT DISTINCT
            spriden_pidm                   w_spriden_pidm,
            spriden_first_name             w_spriden_first_name,
            spriden_last_name              w_spriden_last_name,
            spriden_id                     w_spriden_id
     FROM
            spriden
     WHERE
            spriden_change_ind IS NULL
            AND spriden_entity_ind = 'P'
            AND spriden_last_name NOT LIKE '%DO%NOT%USE%'
)

SELECT DISTINCT
    w_spriden_first_name                          FirstName,
    w_spriden_last_name                           LastName,
    w_spriden_id                                  BannerID,
    gobtpac_external_user                         Username
FROM
         pebempl
         LEFT JOIN w_spriden ON w_spriden_pidm = pebempl_pidm
         LEFT JOIN gobtpac ON gobtpac_pidm = pebempl_pidm

WHERE
     (
      (UPPER(w_spriden_last_name) LIKE ('%' || UPPER(:Edit1) || '%'))
      OR
      (w_spriden_id = UPPER(:Edit1))
      OR
      (gobtpac_external_user LIKE ('%' || (:Edit1) || '%'))
     )
    AND :btnGo != 0
ORDER BY
    LastName
