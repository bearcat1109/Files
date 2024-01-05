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
    spriden_id                                id,
    spriden_last_name                         last_name,
    spriden_first_name                        first_name,
    gobtpac_external_user || '@nsuok.edu'     email,
    CASE
        WHEN spbpers_ethn_code = '1' THEN
            '2'
        ELSE
            NULL
    END                                       race_black,
    spbpers_citz_code                         citizenship_type,
    CASE
        WHEN spbpers_ethn_code = '2' THEN
            '3'
        ELSE
            NULL
    END                                       race_native,
    CASE
        WHEN spbpers_ethn_code = '3' THEN
            '4'
        ELSE
            NULL
    END                                       race_asian,
    CASE
        WHEN spbpers_ethn_code = '4' THEN
            '5'
        ELSE
            NULL
    END                                       race_hispanic,
    CASE
        WHEN spbpers_ethn_code = '5' THEN
            '6'
        ELSE
            NULL
    END                                       race_white,
    CASE
        WHEN spbpers_ethn_code = '3' THEN
            '4'
        ELSE
            NULL
    END                                       race_hawpac,
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
        END AS classification,
    (select SFBETRM_MIN_HRS 
    from SFBETRM 
    where sgrsprt_pidm = SFBETRM_PIDM 
    and SFBETRM_TERM_CODE = 202420)           minimum_hours,
    ''                                        bill_hrs
    -- bill hrs and credit hrs in sfrstcr
FROM 
    sgrsprt 
    JOIN w_sgrsprt ON w_sgrsprt_pidm = sgrsprt_pidm
    LEFT JOIN sfbetrm ON sfbetrm_pidm = w_sgrsprt_pidm
        AND sfbetrm_term_code = 202420
    LEFT JOIN spriden ON spriden_pidm = sgrsprt_pidm
        AND spriden_change_ind IS NULL
    LEFT JOIN gobtpac ON gobtpac_pidm = sgrsprt_pidm
    LEFT JOIN sgbstdn ON sgbstdn_pidm = sgrsprt_pidm
    JOIN spbpers ON spbpers_pidm = sgrsprt_pidm
    -- Classification
    JOIN sgrsatt ON sgrsatt_pidm = sfbetrm_pidm
        AND sgrsatt_term_code_eff = 
        (
            SELECT
                MAX(s1.sgrsatt_term_code_eff)
            FROM
                sgrsatt s1
            WHERE
                s1.sgrsatt_pidm = sgrsprt_pidm
        )
    JOIN shrtgpa ON shrtgpa_pidm = sgrsprt_pidm
        AND shrtgpa_levl_code = sgbstdn_levl_code
        AND  ((SHRTGPA_TERM_CODE < 202420
                AND SHRTGPA_GPA_TYPE_IND = 'I')
                    OR
                (SHRTGPA_TERM_CODE <= 202420
                AND SHRTGPA_GPA_TYPE_IND = 'T'))
;        
  
