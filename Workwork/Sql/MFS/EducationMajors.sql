-- Education Majors - MFS. Written 12-19-2023 Gabriel Berres.

-- ID, Tax_Id, Last_name, first_name, middle_name, major, major_desc, first_concentration,
-- first_concentration_desc, enrollment_status, current_age

WITH w_sgbstdn AS (
    SELECT DISTINCT
        sgbstdn_pidm                    w_sgbstdn_pidm,
        MAX(sgbstdn_term_code_eff)
        OVER(PARTITION BY sgbstdn_pidm) w_sgbstdn_term_code_eff
    FROM
        sgbstdn
    WHERE
        sgbstdn_term_code_eff <= 202420
)
SELECT DISTINCT
    spriden_id                  id,
    spbpers_ssn                 tax_id,
    spriden_last_name           last,
    spriden_first_name          first,
    spriden_mi                  middle,
    m_stvmajr.stvmajr_code      major,
    m_stvmajr.stvmajr_desc      major_desc,
    c_stvmajr.stvmajr_code      first_concentration,
    c_stvmajr.stvmajr_desc      first_concentration_desc,
    sfbetrm_ests_code           enrollment_status,
    TRUNC(MONTHS_BETWEEN(SYSDATE, spbpers_birth_date) / 12) AS Age
FROM
    sfbetrm
    JOIN w_sgbstdn ON w_sgbstdn_pidm = sfbetrm_pidm
    JOIN sgbstdn ON sgbstdn_pidm = sfbetrm_pidm
        AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
        AND sgbstdn_stst_code NOT IN ('IS','IG')
    JOIN spbpers ON spbpers_pidm = sfbetrm_pidm
    LEFT JOIN spriden ON spriden_pidm = sfbetrm_pidm
        AND spriden_change_ind IS NULL
    
    JOIN stvmajr m_stvmajr ON m_stvmajr.stvmajr_code = sgbstdn_majr_code_1
    LEFT JOIN stvmajr c_stvmajr ON c_stvmajr.stvmajr_code = sgbstdn_majr_code_conc_1
WHERE
    sfbetrm_ests_code = 'EL'        --:main_mc_ests.enrollment_status
    AND sfbetrm_term_code = 202420      --:main_mc_ests.enrollment_status
    AND m_stvmajr.stvmajr_desc LIKE '%Educ%'
;
    
    
    
