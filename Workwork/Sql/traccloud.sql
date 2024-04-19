-- First Name, Last Name, Student ID, Student Email, Student Type, Classification, 
--Major, Concentration, Tribe 1 & Tribe_Desc, Tribe 2 & Tribe_Desc, Tribe 3 & Tribe_Desc

-- TracCloud datafeed report. Written 4-18-2024 Programmer Team
WITH gortrib AS (
    SELECT
        g2.gorprac_pidm gortrib_pidm,
        g2.gorprac_race_cde gortrib_race_code,
        ROW_NUMBER()
        OVER(PARTITION BY g2.gorprac_pidm
             ORDER BY
                 g2.gorprac_race_cde
        ) AS gortrib_trib_number
    FROM
        gorprac g2,
        (
            SELECT
                COUNT(gorprac_pidm),
                gorprac_pidm
            FROM
                gorprac
            WHERE
                ( substr(gorprac_race_cde, 1, 1) IN ( '0', '9' )
                  AND length(gorprac_race_cde) = 3 )
            GROUP BY
                gorprac_pidm
            HAVING
                COUNT(gorprac_pidm) < 4
        )       tb1
    WHERE
            g2.gorprac_pidm = tb1.gorprac_pidm
        AND substr(g2.gorprac_race_cde, 1, 1) IN ( '0', '9' )
        AND length(g2.gorprac_race_cde) = 3
    ORDER BY
        1,
        2
)

SELECT DISTINCT
    spriden_first_name First_Name,
    spriden_last_name Last_Name, 
    spriden_id Other_ID,
    gobtpac_external_user || '@nsuok.edu' Email,
    nvl(sorlcur_styp_code, sgbstdn_styp_code) student_type,
    stvclas_desc Class,
    ma_stvmajr.stvmajr_desc Major,
    co_stvmajr.stvmajr_desc concentration,
    t1.gortrib_race_code                      tribe1,
    g1.gorrace_desc                           tribe1_desc,
    t2.gortrib_race_code                      tribe2,
    g2.gorrace_desc                           tribe2_desc,
    t3.gortrib_race_code                      tribe3,
    g3.gorrace_desc                           tribe3_desc,
    spbpers_confid_ind                        confidential_ind
FROM 
    sfbetrm
    -- Identification
    LEFT JOIN spriden on spriden_pidm = sfbetrm_pidm
        AND spriden_change_ind IS NULL
        AND spriden_entity_ind = 'P'
    LEFT JOIN gobtpac ON gobtpac_pidm = sfbetrm_pidm
    JOIN spbpers ON spbpers_pidm = sfbetrm_pidm
    -- Student
    JOIN sgbstdn ON sgbstdn_pidm = sfbetrm_pidm
        AND sgbstdn_term_code_eff = (SELECT
            MAX(s1.sgbstdn_term_code_eff)
        FROM
            sgbstdn s1
        WHERE
            s1.sgbstdn_pidm = sfbetrm_pidm)
    JOIN stvclas ON stvclas_code = sgkclas.f_class_code(sfbetrm_pidm, sgbstdn_levl_code, (
        SELECT 
            MAX(stvterm_code)
        FROM
            stvterm
        WHERE
            stvterm_start_date <= sysdate
    ))
    -- Major/Minor
    JOIN stvmajr ma_stvmajr ON sgbstdn_majr_code_1 = ma_stvmajr.stvmajr_code
    LEFT JOIN stvmajr co_stvmajr ON sgbstdn_majr_code_conc_1 = co_stvmajr.stvmajr_code
    -- Class
    JOIN sorlcur ON sorlcur_pidm = sfbetrm_pidm
    AND sorlcur_seqno = (SELECT
            MAX(s1.sorlcur_seqno)
        FROM
            sorlcur s1
        WHERE
            s1.sorlcur_pidm = sfbetrm_pidm)
    -- GORTRIB (Gor+tribe) 1, 2, 3
    JOIN gortrib t1 ON t1.gortrib_pidm = sfbetrm_pidm
        AND t1.gortrib_trib_number = 1
    JOIN gorrace g1 ON g1.gorrace_race_cde = t1.gortrib_race_code
    
    LEFT JOIN gortrib t2 ON t2.gortrib_pidm = sfbetrm_pidm
        AND t2.gortrib_trib_number = 2
    LEFT JOIN gorrace g2 ON g2.gorrace_race_cde = t2.gortrib_race_code
        
    LEFT JOIN gortrib t3 ON t3.gortrib_pidm = sfbetrm_pidm
        AND t3.gortrib_trib_number = 3
    LEFT JOIN gorrace g3 ON g3.gorrace_race_cde = t3.gortrib_race_code
WHERE
    sfbetrm_term_code = 
    (
        SELECT 
            MAX(stvterm_code)
        FROM
            stvterm
        WHERE
            stvterm_start_date <= sysdate
    )
ORDER BY
    1, 2
;
