SELECT * FROM sgbstdn where sgbstdn_pidm = 228479;
select * from sfbetrm;
select * from spbpers;
select * from sgrsprt where sgrsprt_term_code = 202420;

-- Athlete's List for Final Grades report. Written 12-18-2023 Gabriel Berres
WITH w_sgbstdn AS (
    SELECT DISTINCT
        sgbstdn_pidm                    w_sgbstdn_pidm,
        MAX(sgbstdn_term_code_eff)
        OVER(PARTITION BY sgbstdn_pidm) w_sgbstdn_term_code_eff
    FROM
        sgbstdn
    WHERE
        sgbstdn_term_code_eff <= 202420
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
    sgbstdn_term_code_eff       academic_period,
    spriden_id                  id,
    spbpers_confid_ind          confidential_ind,
    spriden_last_name           last_name,
    spriden_first_name          first_name,
    m_stvmajr.stvmajr_desc      major_desc,
    c_stvmajr.stvmajr_desc      first_concentration_desc,
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
    )                           activity_desc1,
    CASE
        WHEN w_sgrsprt_spst_code = 'AN' THEN
            'Active Non-scholarship'
        WHEN w_sgrsprt_spst_code = 'AS' THEN
            'Active Scholarship'
        WHEN w_sgrsprt_spst_code = 'IN' THEN
            'Inactive Non-scholarship'
        WHEN w_sgrsprt_spst_code = 'IS' THEN
            'Inactive Scholarship'
        ELSE
            ''
    END                                       AS sport_status_desc1
FROM 
    sfbetrm
    JOIN w_sgbstdn ON w_sgbstdn_pidm = sfbetrm_pidm
    JOIN sgbstdn ON sgbstdn_pidm = sfbetrm_pidm
        AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
        AND sgbstdn_stst_code NOT IN ('IS','IG')
    JOIN spriden ON sfbetrm_pidm = spriden_pidm
        AND spriden_change_ind IS NULL
    JOIN spbpers ON spbpers_pidm = sfbetrm_pidm
    JOIN stvmajr m_stvmajr ON m_stvmajr.stvmajr_code = sgbstdn_majr_code_1
    LEFT JOIN stvmajr c_stvmajr ON c_stvmajr.stvmajr_code = sgbstdn_majr_code_conc_1
    LEFT JOIN w_sgrsprt ON w_sgrsprt_pidm = sfbetrm_pidm 
    LEFT JOIN sgrsprt ON sgrsprt_pidm = w_sgrsprt_pidm
        AND w_sgrsprt_term_code = sgrsprt_term_code
WHERE
    sfbetrm_term_code = 202420              --:main_mc_terms.stvterm_code
    AND sfbetrm_ests_code = 'EL'            --:main_mc_ests.enrollment_status
ORDER BY
    ID ASC
;
