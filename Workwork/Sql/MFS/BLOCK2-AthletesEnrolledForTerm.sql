-- Athletes Enrolled For Term - MFS
-- Started 1/5/2023 Gabriel Berres

-- Academic_period, activity_desc1, sport_status_desc1, activity_desc2, sport_status_desc2, confidential_ind, ID, Last_name, 
-- First_name, nsu_email, citizenship_type, race_black, citizenship_type, race_native, race_asian, race_hispanic, race_white, race_hawpac, 
-- classification, academic_standing, minimum_hours, bill_hrs, credit_hrs, overall_earned_hrs, cumulative_hrs, inst_earned_hrs, inst_gpa, 
-- xfer_gpa, college, major, concentration, minor, primary_advisor, athl_advisor, tahlequah, muskogee, broken arrow

WITH w_sgrsprt AS (
    SELECT DISTINCT
        sgrsprt_pidm                    w_sgrsprt_pidm,
--        MAX(sgrsprt_term_code)
--        OVER(PARTITION BY sgrsprt_pidm) w_sgrsprt_term_code,
        sgrsprt_term_code               w_sgrsprt_term_code,
        sgrsprt_elig_code               w_sgrsprt_elig_code,
        sgrsprt_athl_aid_ind            w_sgrsprt_athl_aid_ind,
        sgrsprt_spst_code               w_sgrsprt_spst_code,
        sgrsprt_actc_code               w_sgrsprt_actc_code
    FROM
        sgrsprt
    WHERE
        sgrsprt_term_code = 202420 --:main_sql_queryterms.stvterm_code
), w_sgradvr AS (
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
)
SELECT DISTINCT 
    sfbetrm_term_code           academic_period,
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
    )                                         activity_desc1,
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
            'Null'
    END                                       AS sport_status_desc1,
    spbpers_confid_ind                        confidential_ind,
    s_spriden.spriden_id                              id,
    s_spriden.spriden_last_name                       last_name,
    s_spriden.spriden_first_name                      first_name,
    gobtpac_external_user || '@nsuok.edu'     email,
    CASE
        WHEN spbpers_ethn_code = '1' THEN
            '2'
        ELSE
            NULL
    END                                       race_black,
    spbpers_citz_code                         citizenship_type,
    stvclas_desc                              classification,
    CASE 
        WHEN 
            sgbstdn_astd_code IS NOT NULL
        THEN
            stvastd_desc
        ELSE
            'Incomplete SGBSTDN Data'
    END                                      academic_standing,
    (select SFBETRM_MIN_HRS 
    from SFBETRM 
    where sgrsprt_pidm = SFBETRM_PIDM 
    and SFBETRM_TERM_CODE = 202420)           minimum_hours,
    (
        SELECT DISTINCT
            SUM(sfrstcr_bill_hr)
        FROM 
            sfrstcr
            JOIN sgrsprt ON sgrsprt_pidm = sfrstcr_pidm
        WHERE
            sfrstcr_pidm = sgrsprt_pidm
            AND sfrstcr_term_code = 202420
    ) bill_hrs,
    -- bill hrs and credit hrs in sfrstcr
    nvl(o_shrlgpa.shrlgpa_hours_earned, 0)    overall_earned_hrs,
    to_char(round(nvl(o_shrlgpa.shrlgpa_gpa, 0.00),
                  2),
            'fm90D00')                        cumulative_gpa,
    nvl(i_shrlgpa.shrlgpa_hours_earned, 0)    inst_earned_hrs,
    to_char(round(nvl(i_shrlgpa.shrlgpa_gpa, 0.00),
                  2),
            'fm90D00')                        inst_gpa,
    t_shrlgpa.shrlgpa_hours_earned            xfer_earned_hrs,
    to_char(round(t_shrlgpa.shrlgpa_gpa, 2),
            'fm90D00')                        xfer_gpa,    
    stvclas_desc                              classification,
    stvcoll_desc                              college_desc,
    ma_stvmajr.stvmajr_desc                   major_desc,
    co_stvmajr.stvmajr_desc                   first_concentration_desc,
    mi_stvmajr.stvmajr_desc                   first_minor_desc,
    prim_spriden.spriden_last_name
    || ', '
    || prim_spriden.spriden_first_name
    || ' '
    || substr(prim_spriden.spriden_mi, 1, 1)
    || '.'                                    primary_advisor,
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
                                            athl_advisor
FROM 
    sgrsprt 
    JOIN w_sgrsprt ON w_sgrsprt_pidm = sgrsprt_pidm
    JOIN w_sgradvr ON w_sgradvr_pidm = sgrsprt_pidm
    
    LEFT JOIN sfbetrm ON sfbetrm_pidm = w_sgrsprt_pidm
        AND sfbetrm_term_code = 202420
    JOIN spriden s_spriden ON s_spriden.spriden_pidm = sfbetrm_pidm
        AND s_spriden.spriden_change_ind IS NULL
        AND s_spriden.spriden_entity_ind = 'P'
    LEFT JOIN gobtpac ON gobtpac_pidm = sgrsprt_pidm
    LEFT JOIN sgbstdn ON sgbstdn_pidm = sgrsprt_pidm
    LEFT JOIN stvastd ON stvastd_code = sgbstdn_astd_code
    JOIN spbpers ON spbpers_pidm = sgrsprt_pidm


    -- Class/College
    JOIN w_sorlcur ON w_sorlcur_pidm = sfbetrm_pidm
    JOIN sorlcur ON sorlcur_pidm = w_sorlcur_pidm
                    AND sorlcur_seqno = w_sorlcur_seqno
    LEFT JOIN stvcoll ON sorlcur_coll_code = stvcoll_code
    JOIN stvclas ON stvclas_code = sgkclas.f_class_code(sfbetrm_pidm, sgbstdn_levl_code, sfbetrm_term_code)
    

    LEFT JOIN shrlgpa o_shrlgpa ON o_shrlgpa.shrlgpa_pidm = sfbetrm_pidm
                     AND o_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                     AND o_shrlgpa.shrlgpa_gpa_type_ind = 'O'
    LEFT JOIN shrlgpa i_shrlgpa ON i_shrlgpa.shrlgpa_pidm = sfbetrm_pidm
                     AND i_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                     AND i_shrlgpa.shrlgpa_gpa_type_ind = 'I'
    LEFT JOIN shrlgpa t_shrlgpa ON t_shrlgpa.shrlgpa_pidm = sfbetrm_pidm
                                   AND t_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                                   AND t_shrlgpa.shrlgpa_gpa_type_ind = 'T'
                                   
    -- Advisors
    JOIN sgradvr prim_sgradvr ON prim_sgradvr.sgradvr_pidm = w_sgradvr_pidm
                    AND prim_sgradvr.sgradvr_term_code_eff = w_sgradvr_term_code_eff
                    AND sgradvr_prim_ind = 'Y'
    JOIN spriden prim_spriden ON prim_spriden.spriden_pidm = prim_sgradvr.sgradvr_advr_pidm
                              AND prim_spriden.spriden_change_ind IS NULL
    
    LEFT JOIN sgradvr athl_sgradvr ON athl_sgradvr.sgradvr_pidm = w_sgradvr_pidm
                    AND athl_sgradvr.sgradvr_term_code_eff = w_sgradvr_term_code_eff
                    AND athl_sgradvr.sgradvr_advr_code = 'ATHL'
    LEFT JOIN spriden athl_spriden ON athl_spriden.spriden_pidm = athl_sgradvr.sgradvr_advr_pidm
                              AND athl_spriden.spriden_change_ind IS NULL  
                              
    -- Majors
    JOIN stvmajr ma_stvmajr ON ma_stvmajr.stvmajr_code = sgbstdn_majr_code_1
    LEFT JOIN stvmajr co_stvmajr ON co_stvmajr.stvmajr_code = sgbstdn_majr_code_conc_1
    LEFT JOIN stvmajr mi_stvmajr ON mi_stvmajr.stvmajr_code = sgbstdn_majr_code_minr_1
;        
  
