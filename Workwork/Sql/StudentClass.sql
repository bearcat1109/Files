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
    sfbetrm_pidm,
    (SUM(shrtgpa_hours_earned) OVER (PARTITION BY shrtgpa_pidm)) sum,
    sgbstdn_levl_code,
    --stvclas_desc    found_by_function
    
    CASE
        WHEN 
            sgbstdn_levl_code = 'GR'
        THEN
            'Graduate Master'
        WHEN
            sgrsatt_atts_code = 'SPEC'
            -- sgrsatt_stts_code = spec is special student, atts_code of post is post-grad
        THEN
            'Special Student'
        WHEN EXISTS (
            SELECT
                s1.sgrsatt_atts_code
            FROM
                sgrsatt s1
            WHERE
                    s1.sgrsatt_term_code_eff = (
                        SELECT
                            MAX(s2.sgrsatt_term_code_eff)
                        FROM
                            sgrsatt s2
                        WHERE
                            s2.sgrsatt_pidm = s1.sgrsatt_pidm
                    )
                AND sgrsatt_atts_code IN ( 'POST', 'PGND' )
                AND s1.sgrsatt_pidm = sfbetrm_pidm
        ) THEN
            'Post-Grad'
        WHEN 
            sgbstdn_levl_code = 'UG' AND (SUM(shrtgpa_hours_earned) OVER (PARTITION BY shrtgpa_pidm)) < 30
        THEN
            'Freshman'
        WHEN
            sgbstdn_levl_code = 'UG' AND (SUM(shrtgpa_hours_earned) OVER (PARTITION BY shrtgpa_pidm)) BETWEEN 30 AND 59.99
        THEN
            'Sophomore'
        WHEN
            sgbstdn_levl_code = 'UG' AND (SUM(shrtgpa_hours_earned) OVER (PARTITION BY shrtgpa_pidm)) BETWEEN 60 AND 89.99
        THEN
            'Junior'
        WHEN
            sgbstdn_levl_code = 'UG' AND (SUM(shrtgpa_hours_earned) OVER (PARTITION BY shrtgpa_pidm)) BETWEEN 90 AND 999
        THEN
            'Senior'
        WHEN
            sgbstdn_levl_code = 'PR'
        THEN
            'First Professional'
        ELSE
            'Other'
        END AS found_by_case
FROM
    sfbetrm
    JOIN w_sgbstdn ON w_sgbstdn_pidm = sfbetrm_pidm
    JOIN sgbstdn ON sgbstdn_pidm = sfbetrm_pidm
        AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
        AND sgbstdn_stst_code NOT IN ('IS','IG')
    --JOIN stvclas ON stvclas_code = sgkclas.f_class_code(sfbetrm_pidm, sgbstdn_levl_code, 202420)
    JOIN sgrsatt ON sgrsatt_pidm = sfbetrm_pidm
        AND sgrsatt_term_code_eff = 
        (
            SELECT
                MAX(s1.sgrsatt_term_code_eff)
            FROM
                sgrsatt s1
            WHERE
                s1.sgrsatt_pidm = sfbetrm_pidm
        )
    JOIN shrtgpa ON shrtgpa_pidm = sfbetrm_pidm
        AND shrtgpa_levl_code = sgbstdn_levl_code
        AND  ((SHRTGPA_TERM_CODE < 202420
                AND SHRTGPA_GPA_TYPE_IND = 'I')
                    OR
                (SHRTGPA_TERM_CODE <= 202420
                AND SHRTGPA_GPA_TYPE_IND = 'T'))
    
WHERE 
    sfbetrm_term_code = 202420
    AND sfbetrm_ests_code = 'EL'
ORDER BY 
    sfbetrm_pidm;
