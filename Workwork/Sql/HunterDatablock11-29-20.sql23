-- Written 11-29-2023. Pulls Employee last name, first name, N#, and
-- username. Made for Hunter.

SELECT DISTINCT
    spriden_first_name                         AS FirstName,
    spriden_last_name                          AS LastName,
    spriden_id                                 AS BannerID,
    gobtpac_external_user                      AS Username
FROM
         pebempl
         LEFT JOIN spriden ON spriden_pidm = pebempl_pidm
         LEFT JOIN gobtpac ON gobtpac_pidm = pebempl_pidm

WHERE
     (
      (UPPER(spriden_last_name) LIKE ('%' || UPPER(:Edit1) || '%'))
      OR
      (UPPER(spriden_first_name) LIKE ('%' || UPPER(:Edit1) || '%'))
      OR
      (spriden_id = UPPER(:Edit1))
      OR
      (gobtpac_external_user LIKE ('%' || (:Edit1) || '%'))
     )
    AND spriden_change_ind IS NULL
    AND spriden_entity_ind = 'P'
    AND :btnGo = 1
ORDER BY
    LastName




-- v2

-- Written 11-29-2023. Pulls Employee last name, first name, N#, and
-- username. Made for Hunter.

WITH w_spriden AS
(
     SELECT DISTINCT
            spriden_pidm                   w_spriden_pidm,
            spriden_last_name              w_spriden_last_name,
            spriden_id                     w_spriden_id
     FROM
            spriden
     WHERE
            spriden_change_ind IS NULL
            AND spriden_entity_ind = 'P'
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
      (UPPER(spriden_last_name) LIKE ('%' || UPPER(:Edit1) || '%'))
      OR
      (UPPER(spriden_first_name) LIKE ('%' || UPPER(:Edit1) || '%'))
      OR
      (spriden_id = UPPER(:Edit1))
      OR
      (gobtpac_external_user LIKE ('%' || (:Edit1) || '%'))
     )
    AND spriden_change_ind IS NULL
    AND spriden_entity_ind = 'P'
    AND :btnGo = 1
ORDER BY
    LastName
