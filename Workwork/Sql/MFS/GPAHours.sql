-- GPA Hours - MFS. Written 12-19-2023 Gabriel Berres

-- Academic_period (term), id, confidential_ind, last_name, first_name, total_gpa_credits

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
    sfbetrm_term_code       academic_period,
    spriden_id              id,
    spriden_last_name       last_name,
    spriden_first_name      first_name,
    o_shrlgpa.shrlgpa_gpa_hours       total_gpa_credits
FROM 
    sfbetrm
    JOIN w_sgbstdn ON w_sgbstdn_pidm = sfbetrm_pidm
    JOIN sgbstdn ON sgbstdn_pidm = w_sgbstdn_pidm
        AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
        AND sgbstdn_stst_code NOT IN ( 'IS', 'IG' )
    JOIN spriden ON sfbetrm_pidm = spriden_pidm
        AND spriden_change_ind IS NULL
    JOIN spbpers ON spbpers_pidm = sfbetrm_pidm
    LEFT JOIN shrlgpa o_shrlgpa ON o_shrlgpa.shrlgpa_pidm = sfbetrm_pidm
        AND o_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
        AND o_shrlgpa.shrlgpa_gpa_type_ind = 'O'
WHERE 
    sfbetrm_term_code = 202420          --:main_mc_term.stvterm_code
    AND sfbetrm_ests_code = 'EL'            --:main_mc_ests.enrollment_status
ORDER BY
    ID ASC
;
