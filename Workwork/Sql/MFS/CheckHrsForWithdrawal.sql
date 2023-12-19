SELECT * FROM sgbstdn where sgbstdn_pidm = 228479;
select * from sfbetrm;
select * from spbpers;
select * from sgrsprt where sgrsprt_term_code = 202420;
select distinct shrtgpa_gpa_type_ind from shrtgpa;
select * from stvests;
select * from sobptrm;
select * from sfrstcr where sfrstcr_term_code = 202420 and sfrstcr_pidm = 228479;

-- Check Hours for Withdrawals report. Written 12-18-2023 Gabriel Berres
-- ID, last, first, enrollment_status, term hours, census hours
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
    spriden_last_name           last_name,
    spriden_first_name          first_name,
    sfbetrm_ests_code           enrollment_status,
    shrtgpa_hours_earned        term_hours,
    -- Census hours needs to be a sum of all classes added before census_date (sobptrm_census_date)
    -- and not dropped before census date
    (
        SELECT
            SUM(sfrstcr_credit_hr)
        FROM
            sfrstcr
        WHERE
            sfrstcr_term_code = 202420
            AND sfrstcr_add_date < 
            (
                SELECT
                    sobptrm_census_date + 1
                FROM 
                    sobptrm
                WHERE
                    sobptrm_term_code = 202420
                    AND sobptrm_ptrm_code = '1'
            )
            AND sfrstcr_pidm = sfbetrm_pidm
    )                   census_hours
FROM 
    sfbetrm
    JOIN w_sgbstdn ON w_sgbstdn_pidm = sfbetrm_pidm
    JOIN sgbstdn ON sgbstdn_pidm = sfbetrm_pidm
        AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
        AND sgbstdn_stst_code NOT IN ('IS','IG')
    JOIN spriden ON sfbetrm_pidm = spriden_pidm
        AND spriden_change_ind IS NULL
    JOIN shrtgpa ON shrtgpa_pidm = sfbetrm_pidm
        AND shrtgpa_term_code = 202420      --:main_mc_terms.stvterm_code
WHERE
    sfbetrm_term_code = 202420              --:main_mc_terms.stvterm_code
    AND sfbetrm_ests_code = 'EL'            --:main_mc_ests.enrollment_status
ORDER BY
    ID ASC
;
