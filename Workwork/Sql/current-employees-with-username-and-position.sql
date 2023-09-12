SELECT 
    spriden_last_name || ', ' || spriden_first_name AS Employee,
    nbbposn_title AS Title,
    gobtpac_external_user AS Username
FROM
         spriden
    JOIN nbrbjob ON spriden_pidm = nbrbjob_pidm
        AND nbrbjob_contract_type = 'P'
        AND ( ( nbrbjob_end_date IS NULL )
            OR ( nbrbjob_end_date >= sysdate ) )
    JOIN nbbposn ON nbrbjob_posn = nbbposn_posn
    JOIN gobtpac ON gobtpac_pidm = spriden_pidm
WHERE
    spriden_change_ind IS NULL
ORDER BY
    spriden_last_name ASC;
