-- MFS to PROD second group - Academic Information to PROD - "All Advisors Assigned to Students by Term"

-- Student_Id, Last Name, First Name, Enroll Status, Primary Advisor, Univ Advisor(always empty), Acad Advisor(Same as primary),
-- Fac Advisor, Majr Advisor, Adp_Advisor, PPH_advisor, Athl Advisor, College, First Major, Second Major, Second Concentration, First Minor,
-- Overall Earned Hrs, CUM GPA, NSU GPA, Email, Classification, Applied For Graduation, Citizenship

WITH w_sgradvr AS (
    SELECT DISTINCT
        sgradvr_pidm                    w_sgradvr_pidm,
        MAX(sgradvr_term_code_eff)
        OVER(PARTITION BY sgradvr_pidm) w_sgradvr_term_code_eff
    FROM
        sgradvr
    WHERE
        sgradvr_term_code_eff <= 202420
), w_sorlcur AS (
    SELECT DISTINCT
        sorlcur_pidm                    w_sorlcur_pidm,
        MAX(sorlcur_seqno)
        OVER(PARTITION BY sorlcur_pidm) w_sorlcur_seqno
    FROM
        sorlcur
), w_sgbstdn AS
(
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
    s_spriden.spriden_id  student_id,
    s_spriden.spriden_last_name   last_name,
    s_spriden.spriden_first_name  first_name,
    stvests_desc        enroll_status,
    prim_spriden.spriden_last_name
    || ', '
    || prim_spriden.spriden_first_name
    || ' '
    || substr(prim_spriden.spriden_mi, 1, 1)
    || '.'                                    primary_advisor,
    CASE 
        WHEN 
            univ_sgradvr.sgradvr_advr_pidm IS NOT NULL
        THEN
    univ_spriden.spriden_last_name
    || ', '
    || univ_spriden.spriden_first_name
    || ' '
    || substr(univ_spriden.spriden_mi, 1, 1)
    || '.'                                    
    ELSE
        ''
    END                                       univ_advisor,
    CASE
        WHEN
            acad_sgradvr.sgradvr_advr_pidm IS NOT NULL THEN
    acad_spriden.spriden_last_name
    || ', '
    || acad_spriden.spriden_first_name
    || ' '
    || substr(acad_spriden.spriden_mi, 1, 1)
    || '.'                                    
    ELSE 
        ''
    END 
                                            acad_advisor,
    CASE
        WHEN
            fac_sgradvr.sgradvr_advr_pidm IS NOT NULL THEN
    fac_spriden.spriden_last_name
    || ', '
    || fac_spriden.spriden_first_name
    || ' '
    || substr(fac_spriden.spriden_mi, 1, 1)
    || '.'                                    
    ELSE 
        ''
    END 
                                            fac_advisor,
    CASE
        WHEN
            majr_sgradvr.sgradvr_advr_pidm IS NOT NULL THEN
    majr_spriden.spriden_last_name
    || ', '
    || majr_spriden.spriden_first_name
    || ' '
    || substr(majr_spriden.spriden_mi, 1, 1)
    || '.'                                    
    ELSE 
        ''
    END 
                                            majr_advisor,
     CASE
        WHEN
            adp_sgradvr.sgradvr_advr_pidm IS NOT NULL THEN
    adp_spriden.spriden_last_name
    || ', '
    || adp_spriden.spriden_first_name
    || ' '
    || substr(adp_spriden.spriden_mi, 1, 1)
    || '.'                                    
    ELSE 
        ''
    END 
                                            adp_advisor,
    CASE
        WHEN
            athl_sgradvr.sgradvr_advr_pidm IS NOT NULL THEN
    athl_spriden.spriden_last_name
    || ', '
    || athl_spriden.spriden_first_name
    || ' '
    || substr(athl_spriden.spriden_mi, 1, 1)
    || '.'
    ELSE
        ''
    END
                                            athl_advisor,
    stvcoll_desc                            college,
    m1_stvmajr.stvmajr_desc                 first_major,
    c1_stvmajr.stvmajr_desc                 first_concentration,
    m2_stvmajr.stvmajr_desc                 second_major,
    c1_stvmajr.stvmajr_desc                 second_concentration,
    min_stvmajr.stvmajr_desc                first_minor,
    nvl(o_shrlgpa.shrlgpa_hours_earned, 0)  overall_earned_hours,
    to_char(round(nvl(o_shrlgpa.shrlgpa_gpa, 0.00),
                  2),'fm90D00')             overall_gpa,
    to_char(round(nvl(n_shrlgpa.shrlgpa_gpa, 0.00),
                  2),'fm90D00')             nsu_gpa,
    gobtpac_external_user || '@nsuok.edu'   email,
--    CASE
--        WHEN 
--            sgbstdn_levl_code = 'GR'
--        THEN
--            'Graduate Master'
--        WHEN
--            sgrsatt_atts_code = 'SPEC'
--            -- sgrsatt_stts_code = spec is special student, atts_code of post is post-grad
--        THEN
--            'Special Student'
--        WHEN EXISTS (
--            SELECT
--                s1.sgrsatt_atts_code
--            FROM
--                sgrsatt s1
--            WHERE
--                    s1.sgrsatt_term_code_eff = (
--                        SELECT
--                            MAX(s2.sgrsatt_term_code_eff)
--                        FROM
--                            sgrsatt s2
--                        WHERE
--                            s2.sgrsatt_pidm = s1.sgrsatt_pidm
--                    )
--                AND sgrsatt_atts_code IN ( 'POST', 'PGND' )
--                AND s1.sgrsatt_pidm = sfbetrm_pidm
--        ) THEN
--            'Post-Grad'
--        WHEN 
--            sgbstdn_levl_code = 'UG' AND (SUM(shrtgpa_hours_earned) OVER (PARTITION BY shrtgpa_pidm)) < 30
--        THEN
--            'Freshman'
--        WHEN
--            sgbstdn_levl_code = 'UG' AND (SUM(shrtgpa_hours_earned) OVER (PARTITION BY shrtgpa_pidm)) BETWEEN 30 AND 59.99
--        THEN
--            'Sophomore'
--        WHEN
--            sgbstdn_levl_code = 'UG' AND (SUM(shrtgpa_hours_earned) OVER (PARTITION BY shrtgpa_pidm)) BETWEEN 60 AND 89.99
--        THEN
--            'Junior'
--        WHEN
--            sgbstdn_levl_code = 'UG' AND (SUM(shrtgpa_hours_earned) OVER (PARTITION BY shrtgpa_pidm)) BETWEEN 90 AND 999
--        THEN
--            'Senior'
--        WHEN
--            sgbstdn_levl_code = 'PR'
--        THEN
--            'First Professional'
--        ELSE
--            'Other'
--        END AS classification,
        stvclas_desc class,
        (select distinct 
            'Y' 
        from 
            shrdgmr 
        where 
            sfbetrm_pidm = shrdgmr_pidm 
            and shrdgmr_term_code_grad = 202420) applied_for_graduation,
        stvcitz_desc                            citizenship
FROM
    sfbetrm
    JOIN spriden s_spriden ON s_spriden.spriden_pidm = sfbetrm_pidm
        AND s_spriden.spriden_change_ind IS NULL
        AND s_spriden.spriden_entity_ind = 'P'
    JOIN stvests ON stvests_code = sfbetrm_ests_code
    JOIN w_sgbstdn ON w_sgbstdn_pidm = sfbetrm_pidm
    JOIN sgbstdn ON sgbstdn_pidm = w_sgbstdn_pidm
        AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
        AND sgbstdn_stst_code NOT IN ( 'IS', 'IG' )
    JOIN spbpers ON spbpers_pidm = sfbetrm_pidm
    JOIN stvcitz ON spbpers_citz_code = stvcitz_code
    JOIN stvclas ON stvclas_code = sgkclas.f_class_code(sfbetrm_pidm, sgbstdn_levl_code, sfbetrm_term_code)
    
    JOIN w_sgradvr ON w_sgradvr_pidm = sfbetrm_pidm
    -- Primary Advisor + Spriden info 
    JOIN sgradvr prim_sgradvr ON prim_sgradvr.sgradvr_pidm = w_sgradvr_pidm
                    AND prim_sgradvr.sgradvr_term_code_eff = w_sgradvr_term_code_eff
                    AND sgradvr_prim_ind = 'Y'
    JOIN spriden prim_spriden ON prim_spriden.spriden_pidm = prim_sgradvr.sgradvr_advr_pidm
                              AND prim_spriden.spriden_change_ind IS NULL
    -- University  Advisor + Spriden info                         
    LEFT JOIN sgradvr univ_sgradvr ON univ_sgradvr.sgradvr_pidm = w_sgradvr_pidm
                    AND univ_sgradvr.sgradvr_term_code_eff = w_sgradvr_term_code_eff
                    AND univ_sgradvr.sgradvr_advr_code = 'UNIV'
    LEFT JOIN spriden univ_spriden ON univ_spriden.spriden_pidm = univ_sgradvr.sgradvr_advr_pidm
                              AND univ_spriden.spriden_change_ind IS NULL
    -- Academic Advisor + Spriden info 
    LEFT JOIN sgradvr acad_sgradvr ON acad_sgradvr.sgradvr_pidm = w_sgradvr_pidm
                    AND acad_sgradvr.sgradvr_term_code_eff = w_sgradvr_term_code_eff
                    AND acad_sgradvr.sgradvr_advr_code = 'AADV'
    LEFT JOIN spriden acad_spriden ON acad_spriden.spriden_pidm = acad_sgradvr.sgradvr_advr_pidm
                              AND acad_spriden.spriden_change_ind IS NULL
   -- Faculty Advisor + Spriden info                           
    LEFT JOIN sgradvr fac_sgradvr ON fac_sgradvr.sgradvr_pidm = w_sgradvr_pidm
                    AND fac_sgradvr.sgradvr_term_code_eff = w_sgradvr_term_code_eff
                    AND fac_sgradvr.sgradvr_advr_code = 'FADV'
    LEFT JOIN spriden fac_spriden ON fac_spriden.spriden_pidm = fac_sgradvr.sgradvr_advr_pidm
                              AND fac_spriden.spriden_change_ind IS NULL
    --Major Advisor + Spriden info                          
    LEFT JOIN sgradvr majr_sgradvr ON majr_sgradvr.sgradvr_pidm = w_sgradvr_pidm
                    AND majr_sgradvr.sgradvr_term_code_eff = w_sgradvr_term_code_eff
                    AND majr_sgradvr.sgradvr_advr_code = 'MAJR'
    LEFT JOIN spriden majr_spriden ON majr_spriden.spriden_pidm = majr_sgradvr.sgradvr_advr_pidm
                              AND majr_spriden.spriden_change_ind IS NULL
    -- ADP Advisor + Spriden info 
    LEFT JOIN sgradvr adp_sgradvr ON adp_sgradvr.sgradvr_pidm = w_sgradvr_pidm
                    AND adp_sgradvr.sgradvr_term_code_eff = w_sgradvr_term_code_eff
                    AND adp_sgradvr.sgradvr_advr_code = 'GUAD'
    LEFT JOIN spriden adp_spriden ON adp_spriden.spriden_pidm = adp_sgradvr.sgradvr_advr_pidm
                              AND adp_spriden.spriden_change_ind IS NULL
    -- PPH Advisor + Spriden info
    LEFT JOIN sgradvr pph_sgradvr ON pph_sgradvr.sgradvr_pidm = w_sgradvr_pidm
                    AND pph_sgradvr.sgradvr_term_code_eff = w_sgradvr_term_code_eff
                    AND pph_sgradvr.sgradvr_advr_code = 'PPH'
    LEFT JOIN spriden pph_spriden ON pph_spriden.spriden_pidm = pph_sgradvr.sgradvr_advr_pidm
                              AND pph_spriden.spriden_change_ind IS NULL
    -- Athletic Advisor + Spriden info
    LEFT JOIN sgradvr athl_sgradvr ON athl_sgradvr.sgradvr_pidm = w_sgradvr_pidm
                    AND athl_sgradvr.sgradvr_term_code_eff = w_sgradvr_term_code_eff
                    AND athl_sgradvr.sgradvr_advr_code = 'ATHL'
    LEFT JOIN spriden athl_spriden ON athl_spriden.spriden_pidm = athl_sgradvr.sgradvr_advr_pidm
                              AND athl_spriden.spriden_change_ind IS NULL      
    -- College/Majors/Minors                
    LEFT JOIN w_sorlcur ON w_sorlcur_pidm = sfbetrm_pidm
        LEFT JOIN sorlcur ON sorlcur_pidm = w_sorlcur_pidm
            AND sorlcur_seqno = w_sorlcur_seqno
        LEFT JOIN stvcoll ON sorlcur_coll_code = stvcoll_code
    JOIN stvmajr m1_stvmajr ON m1_stvmajr.stvmajr_code = sgbstdn_majr_code_1
        LEFT JOIN stvmajr m2_stvmajr ON m2_stvmajr.stvmajr_code = sgbstdn_majr_code_2
        LEFT JOIN stvmajr c1_stvmajr ON c1_stvmajr.stvmajr_code = sgbstdn_majr_code_conc_1
        LEFT JOIN stvmajr c2_stvmajr ON c2_stvmajr.stvmajr_code = sgbstdn_majr_code_conc_2
        LEFT JOIN stvmajr min_stvmajr ON min_stvmajr.stvmajr_code = sgbstdn_majr_code_minr_1
    -- GPA
    LEFT JOIN shrlgpa o_shrlgpa ON o_shrlgpa.shrlgpa_pidm = sfbetrm_pidm
                     AND o_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                     AND o_shrlgpa.shrlgpa_gpa_type_ind = 'O'
    LEFT JOIN shrlgpa n_shrlgpa ON n_shrlgpa.shrlgpa_pidm = sfbetrm_pidm
                     AND n_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                     AND n_shrlgpa.shrlgpa_gpa_type_ind = 'I'
    JOIN gobtpac on gobtpac_pidm = sfbetrm_pidm
    -- Classification
--    JOIN sgrsatt ON sgrsatt_pidm = sfbetrm_pidm
--        AND sgrsatt_term_code_eff = 
--        (
--            SELECT
--                MAX(s1.sgrsatt_term_code_eff)
--            FROM
--                sgrsatt s1
--            WHERE
--                s1.sgrsatt_pidm = sfbetrm_pidm
--        )
--    JOIN shrtgpa ON shrtgpa_pidm = sfbetrm_pidm
--        AND shrtgpa_levl_code = sgbstdn_levl_code
--        AND  ((SHRTGPA_TERM_CODE < 202420
--                AND SHRTGPA_GPA_TYPE_IND = 'I')
--                    OR
--                (SHRTGPA_TERM_CODE <= 202420
--                AND SHRTGPA_GPA_TYPE_IND = 'T'))
WHERE
    sfbetrm_term_code = 202420--:main_mc_term.value
    AND sgbstdn_majr_code_1 = '7602' --:main_mc_major.major
    AND nvl(sorlcur_styp_code, sgbstdn_styp_code) IN ('A','C','F','N','O','R','T')
    --AND ROW_NUMBER() OVER (PARTITION BY SORLCUR_PIDM, SGBSTDN_TERM_CODE_EFF ORDER BY SORLCUR_PRIORITY_NO) = '1'
