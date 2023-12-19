-- Undergrad Enroll for OHLAP

-- ID, SSN, Last, First, Status, Class, Term Hours

select * from stvclas;

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
        spriden_id          ID,
        spbpers_ssn         SSN,
        spriden_last_name   LAST,
        spriden_first_name  FIRST,
        sfbetrm_ests_code   STATUS,
        stvclas_desc        CLASS   
FROM
    sfbetrm
    LEFT JOIN spriden ON spriden_pidm = sfbetrm_pidm
        AND spriden_change_ind IS NULL
        AND spriden_entity_ind = 'P'
    JOIN spbpers ON spbpers_pidm = sfbetrm_pidm
    JOIN w_sgbstdn ON w_sgbstdn_pidm = sfbetrm_pidm
    JOIN sgbstdn ON sgbstdn_pidm = sfbetrm_pidm
        AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
        AND sgbstdn_stst_code NOT IN ('IS','IG')
    JOIN stvclas ON stvclas_code = sgkclas.f_class_code(sfbetrm_pidm, sgbstdn_levl_code, 202420)
WHERE
    sfbetrm_term_code = 202420     ----:main_mc_term.stvterm_code
    AND sfbetrm_ests_code = 'EL'           --:main_mc_ests.enrollment_status
    AND stvclas_code < 6
ORDER BY
    ID ASC
;
