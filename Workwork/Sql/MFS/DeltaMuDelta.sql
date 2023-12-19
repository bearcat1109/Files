-- Delta Mu Delta List - Written 12-19-2023 Gabriel Berres
-- Term , ID, Last, First, Middle, Suffix, Major, Concentration, Age, Overall Earned Hrs,
-- Overall GPA,  NSU Earned hrs, Classification, Mailing Address, Permanent Address,
-- NSU email, Confidential_Ind

WITH w_sgbstdn AS (
    SELECT DISTINCT
        sgbstdn_pidm                    w_sgbstdn_pidm,
        MAX(sgbstdn_term_code_eff)
        OVER(PARTITION BY sgbstdn_pidm) w_sgbstdn_term_code_eff
    FROM
        sgbstdn
    WHERE
        sgbstdn_term_code_eff <= :main_mc_term.stvterm_code
)
SELECT DISTINCT
    spriden_id              id,
    spriden_last_name       last,
    spriden_first_name      first,
    spriden_mi              middle,
    CASE
        WHEN
            spbpers_name_suffix IS NOT NULL
        THEN
            spbpers_name_suffix
        ELSE
            ''
    END AS                  suffix,
    m_stvmajr.stvmajr_desc  major,
    c_stvmajr.stvmajr_desc  concentration,
    TRUNC(MONTHS_BETWEEN(SYSDATE, spbpers_birth_date) / 12) AS Age,
    nvl(o_shrlgpa.shrlgpa_hours_earned, 0)    overall_earned_hrs,
    to_char(round(nvl(o_shrlgpa.shrlgpa_gpa, 0.00),
                  2),
            'fm90D00')                        overall_gpa,
    nvl(i_shrlgpa.shrlgpa_hours_earned, 0)    nsu_earned_hrs,
    stvclas_desc                              classification,
    (
        SELECT
            w_spraddr_street_line1
            || '|'
            || w_spraddr_street_line1
            || '|'
            || w_spraddr_city
            || '|'
            || w_spraddr_stat_code
            || '|'
            || w_spraddr_zip
            || '|'
            || w_spraddr_natn_code
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_street_line2 w_spraddr_street_line2,
                    spraddr_city         w_spraddr_city,
                    spraddr_stat_code    w_spraddr_stat_code,
                    spraddr_zip          w_spraddr_zip,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'MA' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = sfbetrm_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         mailing_address,
        (
        SELECT
            w_spraddr_street_line1
            || '|'
            || w_spraddr_street_line1
            || '|'
            || w_spraddr_city
            || '|'
            || w_spraddr_stat_code
            || '|'
            || w_spraddr_zip
            || '|'
            || w_spraddr_natn_code
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_street_line2 w_spraddr_street_line2,
                    spraddr_city         w_spraddr_city,
                    spraddr_stat_code    w_spraddr_stat_code,
                    spraddr_zip          w_spraddr_zip,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'PR' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = sfbetrm_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         permanent_address,
    gobtpac_external_user || '@nsuok.edu'     nsu_email,
    spbpers_confid_ind                        confidential_ind
FROM
    sfbetrm
    JOIN w_sgbstdn ON w_sgbstdn_pidm = sfbetrm_pidm
    JOIN sgbstdn ON sgbstdn_pidm = sfbetrm_pidm
        AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
        AND sgbstdn_stst_code NOT IN ('IS','IG')
    JOIN spriden ON sfbetrm_pidm = spriden_pidm
        AND spriden_change_ind IS NULL
    JOIN shrtgpa ON shrtgpa_pidm = sfbetrm_pidm
        AND shrtgpa_term_code = :main_mc_term.stvterm_code
    JOIN spbpers ON spbpers_pidm = sfbetrm_pidm
    JOIN gobtpac ON gobtpac_pidm = sfbetrm_pidm

    JOIN stvmajr m_stvmajr ON m_stvmajr.stvmajr_code = sgbstdn_majr_code_1
    LEFT JOIN stvmajr c_stvmajr ON c_stvmajr.stvmajr_code = sgbstdn_majr_code_conc_1
    LEFT JOIN stvcoll ON stvcoll_code = sgbstdn_coll_code_1
        JOIN stvclas ON stvclas_code = sgkclas.f_class_code(sfbetrm_pidm, sgbstdn_levl_code, :main_mc_term.stvterm_code)

    LEFT JOIN shrlgpa o_shrlgpa ON o_shrlgpa.shrlgpa_pidm = sfbetrm_pidm
                                   AND o_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                                   AND o_shrlgpa.shrlgpa_gpa_type_ind = 'O'
    LEFT JOIN shrlgpa i_shrlgpa ON i_shrlgpa.shrlgpa_pidm = sfbetrm_pidm
                                   AND i_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                                   AND i_shrlgpa.shrlgpa_gpa_type_ind = 'I'
WHERE
    sfbetrm_term_code = :main_mc_term.stvterm_code              --:main_mc_term.stvterm_code
    AND sfbetrm_ests_code = :main_mc_ests.enrollment_status           --:main_mc_ests.enrollment_status
    AND sgbstdn_coll_code_1 = 'BT'
    AND stvclas_code IN ('3', '4', '7')
;
