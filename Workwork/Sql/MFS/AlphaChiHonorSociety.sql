-- Alpha Chi Honor Society round 2
-- Written 11-29-2023


WITH w_sgbstdn AS
(
    SELECT DISTINCT
        sgbstdn_pidm                    w_sgbstdn_pidm,
        MAX(sgbstdn_term_code_eff)
        OVER(PARTITION BY sgbstdn_pidm) w_sgbstdn_term_code_eff,
        sgbstdn_majr_code_1             w_sgbstdn_majr_code_1,
        sgbstdn_majr_code_conc_1        w_sgbstdn_majr_code_conc_1
    FROM
        sgbstdn
    WHERE
        sgbstdn_term_code_eff <= 202420
)
SELECT DISTINCT
    s_spriden.spriden_id                                            ID,
    s_spriden.spriden_last_name                                     LAST,
    s_spriden.spriden_first_name                                    FIRST,
    s_spriden.spriden_mi                                            MIDDLE,
    nvl(o_shrlgpa.shrlgpa_hours_earned, 0)                  OVERALL_EARNED_HOURS,
    to_char(round(nvl(o_shrlgpa.shrlgpa_gpa, 0.00),
                  2),'fm90D00')                             OVERALL_GPA,
    nvl(n_shrlgpa.shrlgpa_hours_earned, 0)                  NSU_GPA,
    to_char(round(nvl(n_shrlgpa.shrlgpa_gpa, 0.00),
                  2),'fm90D00')                             NSU_GPA,
    shrtgpa_hours_earned                                    TERM_HOURS,
    stvclas_desc                                            CLASSIFICATION,
    m_stvmajr.stvmajr_desc                                  MAJOR,
    c_stvmajr.stvmajr_desc                                  CONCENTRATION,
    gobtpac_external_user || '@nsuok.edu'                   NSU_EMAIL,
    LOWER((
        SELECT
            goremal_email_address
        FROM
            goremal
        WHERE
                goremal_emal_code = 'PERS'
            AND goremal_status_ind = 'A'
            AND goremal_pidm = sfbetrm_pidm
        ORDER BY
            goremal_activity_date DESC
        FETCH FIRST 1 ROWS ONLY
    ))                                                      PERSONAL_EMAIL,
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
    )                                         PERMANENT_ADDRESS,
    spbpers_confid_ind                        CONFIDENTIAL_IND,
    sfbetrm_ests_code                         ENROLLMENT_STATUS
FROM 
        sfbetrm
    JOIN spriden s_spriden ON sfbetrm_pidm = s_spriden.spriden_pidm
                    AND s_spriden.spriden_change_ind IS NULL
    JOIN w_sgbstdn ON w_sgbstdn_pidm = sfbetrm_pidm
    JOIN sgbstdn ON sgbstdn_pidm = w_sgbstdn_pidm
                    AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
                    AND sgbstdn_stst_code NOT IN ( 'IS', 'IG' ) 
    LEFT JOIN shrtgpa ON shrtgpa_pidm = sfbetrm_pidm
                    AND shrtgpa_term_code = 202420
    JOIN gobtpac ON gobtpac_pidm = sfbetrm_pidm
    JOIN stvclas ON stvclas_code = sgkclas.f_class_code(sfbetrm_pidm, sgbstdn_levl_code, 202420)
    LEFT JOIN shrlgpa o_shrlgpa ON o_shrlgpa.shrlgpa_pidm = sfbetrm_pidm
                     AND o_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                     AND o_shrlgpa.shrlgpa_gpa_type_ind = 'O'
    LEFT JOIN shrlgpa n_shrlgpa ON n_shrlgpa.shrlgpa_pidm = sfbetrm_pidm
                     AND n_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                     AND n_shrlgpa.shrlgpa_gpa_type_ind = 'I'
    LEFT JOIN shrlgpa t_shrlgpa ON t_shrlgpa.shrlgpa_pidm = sfbetrm_pidm
                     AND t_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                     AND t_shrlgpa.shrlgpa_gpa_type_ind = 'T'
    JOIN stvmajr m_stvmajr ON m_stvmajr.stvmajr_code = sgbstdn_majr_code_1
    LEFT JOIN stvmajr c_stvmajr ON c_stvmajr.stvmajr_code = sgbstdn_majr_code_conc_1     
    JOIN spbpers ON spbpers_pidm = sfbetrm_pidm
WHERE
    sfbetrm_term_code = 202420
    AND sfbetrm_ests_code = 'EL'
;
