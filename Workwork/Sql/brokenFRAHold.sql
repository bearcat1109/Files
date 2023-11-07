WITH w_sarappd AS (
    SELECT
        sarappd_pidm                    w_sarappd_pidm,
        MIN(sarappd_term_code_entry)
        OVER(PARTITION BY sarappd_pidm) w_sarappd_term_code_entry
    FROM
        sarappd
    WHERE
        sarappd_apdc_code NOT IN ( 'GN', 'DN' )
), w_sfrstcr AS (
    SELECT DISTINCT
        c_sfrstcr_pidm      w_sfrstcr_pidm,
        c_sfrstcr_crn       w_sfrstcr_crn,
        c_sfrstcr_rsts_date w_sfrstcr_rsts_date,
        sfrstcr_rsts_code   w_sfrstcr_rsts_code
    FROM
             (
            SELECT DISTINCT
                sfrstcr_pidm                                 c_sfrstcr_pidm,
                sfrstcr_crn                                  c_sfrstcr_crn,
                MAX(sfrstcr_rsts_date)
                OVER(PARTITION BY sfrstcr_pidm, sfrstcr_crn) c_sfrstcr_rsts_date
            FROM
                sfrstcr
            WHERE
                sfrstcr_term_code = :lbSemYear
        ) c_sftsrcr
        JOIN sfrstcr ON sfrstcr_pidm = c_sfrstcr_pidm
                        AND sfrstcr_crn = c_sfrstcr_crn
                        AND sfrstcr_rsts_date = c_sfrstcr_rsts_date
    WHERE
        sfrstcr_rsts_code IN ( 'RE', 'RW', 'AU', 'RA', 'RF' )
)
SELECT DISTINCT
    spriden_id ID,
    --spriden_pidm,
    spriden_first_name FIRSTNAME,
    spriden_last_name LASTNAME,
    CASE
        WHEN sprhold_reason IS NULL THEN
            'Missing FRA Hold'
        ELSE
            'FRA Hold Present'
    END as HOLD_STATUS
FROM
         spriden
    JOIN sfbetrm ON sfbetrm_pidm = spriden_pidm
                    AND sfbetrm_term_code = :lbSemYear
    JOIN w_sfrstcr ON w_sfrstcr_pidm = spriden_pidm
    JOIN w_sarappd ON w_sarappd_pidm = spriden_pidm
                      AND w_sarappd_term_code_entry = :lbSemYear
    LEFT JOIN sprhold ON sprhold_pidm = spriden_pidm
                    AND substr(sprhold_reason, 1, 8) = 'Fin Resp'
                    AND substr(sprhold_reason, - 6, 6) = :lbSemYear
WHERE
    spriden_change_ind IS NULL
    AND sprhold_reason IS NULL
