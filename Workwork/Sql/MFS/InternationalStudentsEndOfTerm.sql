-- International Students End of Term - MFS. Written 12-20-2023 Gabriel Berres.

-- Academic_period, ID, Last_name, First_name, Middle_name, Enrollment_status, stuident_class_boap_desc,
-- Overall_earned_hrs, cumulative_gpa, term_hours, census_hours, nation_of_citizenship_desc(stvnatn_nation), citizenship_desc

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
        spriden_last_name   Last_name,
        spriden_first_name  First_name,
        spriden_mi          Middle_name,
        sfbetrm_ests_code   Enrollment_status,
        stvclas_desc        Student_class_boap_desc,
        nvl(o_shrlgpa.shrlgpa_hours_earned, 0)    Overall_earned_hrs,
        to_char(round(nvl(o_shrlgpa.shrlgpa_gpa, 0.00),
                  2),
            'fm90D00')                            Cumulative_gpa,
        shrtgpa_hours_earned                      Term_hours,
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
    )                                             Census_hours,
    stvnatn_nation                                Nation_of_citizenship_desc,
    stvcitz_desc                                  Citizenship_desc                             
FROM 
    sfbetrm
    LEFT JOIN spriden ON spriden_pidm = sfbetrm_pidm
        AND spriden_change_ind IS NULL
        AND spriden_entity_ind = 'P'
    JOIN spbpers ON spbpers_pidm = sfbetrm_pidm
    JOIN stvcitz ON stvcitz_code = spbpers_citz_code
    JOIN gobintl ON gobintl_pidm = sfbetrm_pidm
    JOIN stvnatn ON stvnatn_code = gobintl_natn_code_birth
    
    JOIN w_sgbstdn ON w_sgbstdn_pidm = sfbetrm_pidm
    JOIN sgbstdn ON sgbstdn_pidm = sfbetrm_pidm
        AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
        AND sgbstdn_stst_code NOT IN ('IS','IG')
    JOIN stvclas ON stvclas_code = sgkclas.f_class_code(sfbetrm_pidm, sgbstdn_levl_code, 202420)
    
    LEFT JOIN shrlgpa o_shrlgpa ON o_shrlgpa.shrlgpa_pidm = sfbetrm_pidm
        AND o_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
        AND o_shrlgpa.shrlgpa_gpa_type_ind = 'O'
    LEFT JOIN shrtgpa ON shrtgpa_pidm = sfbetrm_pidm
        AND shrtgpa_term_code = 202420      --:main_mc_term.stvterm_code
WHERE 
    sfbetrm_term_code = 202420
    AND sfbetrm_ests_code = 'EL'
ORDER BY
    ID ASC
;        
