-- Enrolled Contact Race FERPA-R. Written 12-19-2023 Gabriel Berres

-- ID, Last_name, First_name, email_address, phone, street_line1, street_line2, city, state_province, postal_code,
-- race_black, race_native, race_asian, race_hispanic, race_white, race_hawpac, activity_desc1, sport_status1, cell_phone

WITH w_sgbstdn AS (
    SELECT DISTINCT
        sgbstdn_pidm                    w_sgbstdn_pidm,
        MAX(sgbstdn_term_code_eff)
        OVER(PARTITION BY sgbstdn_pidm) w_sgbstdn_term_code_eff
    FROM
        sgbstdn
    WHERE
        sgbstdn_term_code_eff <= 202420
), w_spraddr_pr AS (
    SELECT
        spraddr_pidm,
        MAX(spraddr_street_line1) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC) w_spraddr_street_line1,
        MAX(spraddr_street_line2) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC) w_spraddr_street_line2,
        MAX(spraddr_city) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC)         w_spraddr_city,
        MAX(spraddr_stat_code) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC)    w_spraddr_stat_code,
        MAX(spraddr_zip) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC)          w_spraddr_zip
    FROM
        spraddr
    WHERE
        sysdate BETWEEN spraddr_from_date AND nvl(spraddr_to_date, sysdate + 1)
        AND spraddr_status_ind IS NULL
        AND nvl(spraddr_natn_code, 'US') = 'US'
        AND spraddr_atyp_code = 'PR'
    GROUP BY
        spraddr_pidm
), w_sgrsprt AS (
    SELECT
        sgrsprt_pidm                    w_sgrsprt_pidm,
        MAX(sgrsprt_term_code)
        OVER(PARTITION BY sgrsprt_pidm) w_sgrsprt_term_code,
        sgrsprt_spst_code               w_sgrsprt_spst_code
    FROM
        sgrsprt
    WHERE
        sgrsprt_term_code <= 202420
)
SELECT DISTINCT
    spriden_id                  id,
    spriden_last_name           last,
    spriden_first_name          first,
    gobtpac_external_user || '@nsuok.edu'   email_address,
    (
        SELECT
            CASE
                WHEN s1.sprtele_phone_area IS NULL THEN
                    NULL
                WHEN s1.sprtele_phone_number IS NULL THEN
                    NULL
                ELSE
                    replace(replace(concat(s1.sprtele_phone_area, s1.sprtele_phone_number),
                                    '-'),
                            '/')
            END phone_number
        FROM
            sprtele s1
        WHERE
                s1.sprtele_pidm = sfbetrm_pidm
            AND s1.sprtele_tele_code = 'PR'
            AND s1.sprtele_status_ind IS NULL
            AND s1.sprtele_primary_ind = 'Y'
            AND length(replace(replace(concat(s1.sprtele_phone_area, s1.sprtele_phone_number),
                                       '-'),
                               '/')) BETWEEN 9 AND 12
            AND s1.sprtele_seqno = (
                SELECT
                    MAX(x1.sprtele_seqno)
                FROM
                    sprtele x1
                WHERE
                        x1.sprtele_pidm = sfbetrm_pidm
                    AND x1.sprtele_tele_code = s1.sprtele_tele_code
                    AND x1.sprtele_status_ind IS NULL
            )
    )                                         phone,
   w_spraddr_street_line1                     street_line1,
   w_spraddr_street_line2                     street_line2,
   w_spraddr_city                             city,
   w_spraddr_stat_code                        state_province,
   w_spraddr_zip                              postal_code,
   CASE
        WHEN spbpers_ethn_code = '1' THEN
            '2'
        ELSE
            NULL
    END                                       race_black,
    CASE
        WHEN spbpers_ethn_code = '2' THEN
            '3'
        ELSE
            NULL
    END                                       race_native,
    CASE
        WHEN spbpers_ethn_code = '3' THEN
            '4'
        ELSE
            NULL
    END                                       race_asian,
    CASE
        WHEN spbpers_ethn_code = '4' THEN
            '5'
        ELSE
            NULL
    END                                       race_hispanic,
    CASE
        WHEN spbpers_ethn_code = '5' THEN
            '6'
        ELSE
            NULL
    END                                       race_white,
    CASE
        WHEN spbpers_ethn_code = '3' THEN
            '4'
        ELSE
            NULL
    END                                       race_hawpac,
    (
        SELECT
            stvactc_desc
        FROM
                 (
                SELECT
                    sgrsprt_actc_code s_sgrsprt_actc_code
                FROM
                    sgrsprt s1
                WHERE
                        s1.sgrsprt_pidm = w_sgrsprt_pidm
                    AND s1.sgrsprt_term_code = w_sgrsprt_term_code
                ORDER BY
                    1
                FETCH FIRST 1 ROWS ONLY
            ) s_sgrsprt
            JOIN stvactc ON stvactc_code = s_sgrsprt_actc_code
    )                                         activity_desc1,
    (
        SELECT
            CASE
                WHEN s1.sprtele_phone_area IS NULL THEN
                    NULL
                WHEN s1.sprtele_phone_number IS NULL THEN
                    NULL
                ELSE
                    replace(replace(concat(s1.sprtele_phone_area, s1.sprtele_phone_number),
                                    '-'),
                            '/')
            END phone_number
        FROM
            sprtele s1
        WHERE
                s1.sprtele_pidm = sfbetrm_pidm
            AND s1.sprtele_tele_code = 'CL'
            AND s1.sprtele_status_ind IS NULL
            AND s1.sprtele_primary_ind = 'Y'
            AND length(replace(replace(concat(s1.sprtele_phone_area, s1.sprtele_phone_number),
                                       '-'),
                               '/')) BETWEEN 9 AND 12
            AND s1.sprtele_seqno = (
                SELECT
                    MAX(x1.sprtele_seqno)
                FROM
                    sprtele x1
                WHERE
                        x1.sprtele_pidm = sfbetrm_pidm
                    AND x1.sprtele_tele_code = s1.sprtele_tele_code
                    AND x1.sprtele_status_ind IS NULL
            )
    )                                          cell_phone
FROM 
    sfbetrm
    JOIN w_sgbstdn ON w_sgbstdn_pidm = sfbetrm_pidm
    JOIN sgbstdn ON sgbstdn_pidm = w_sgbstdn_pidm
        AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
        AND sgbstdn_stst_code NOT IN ( 'IS', 'IG' )
    JOIN spriden ON sfbetrm_pidm = spriden_pidm
        AND spriden_change_ind IS NULL
    JOIN spbpers ON spbpers_pidm = sfbetrm_pidm
    LEFT JOIN w_spraddr_pr ON w_spraddr_pr.spraddr_pidm = sfbetrm_pidm
    JOIN gobtpac ON gobtpac_pidm = sfbetrm_pidm
    
    LEFT JOIN w_sgrsprt ON w_sgrsprt_pidm = sfbetrm_pidm 
    LEFT JOIN sgrsprt ON sgrsprt_pidm = w_sgrsprt_pidm
        AND w_sgrsprt_term_code = sgrsprt_term_code
WHERE 
    sfbetrm_term_code = 202420          --:main_mc_term.stvterm_code
    AND sfbetrm_ests_code = 'EL'            --:main_mc_ests.enrollment_status
;
