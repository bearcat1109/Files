WITH w_sgrsprt AS (
    SELECT DISTINCT
        sgrsprt_pidm                    w_sgrsprt_pidm,
        MAX(sgrsprt_term_code)
        OVER(PARTITION BY sgrsprt_pidm) w_sgrsprt_term_code,
        sgrsprt_elig_code               w_sgrsprt_elig_code,
        sgrsprt_athl_aid_ind            w_sgrsprt_athl_aid_ind,
        sgrsprt_spst_code               w_sgrsprt_spst_code,
        sgrsprt_actc_code               w_sgrsprt_actc_code
    FROM
        sgrsprt
--    WHERE
--        sgrsprt_term_code = 202420
), w_spriden AS 
(
    SELECT DISTINCT 
            spriden_pidm            w_spriden_pidm,
            spriden_id              w_spriden_id,
            spriden_last_name       w_spriden_last_name,
            spriden_first_name      w_spriden_first_name
    FROM 
        spriden
    WHERE 
        spriden_change_ind IS NULL
        AND spriden_entity_ind = 'P'
)
SELECT DISTINCT
    w_spriden_id                                id,
    w_sgrsprt_term_code                         term,
    w_spriden_last_name                         last_name,
    w_spriden_first_name                        first_name,
    gobtpac_external_user || '@nsuok.edu'     email_address,
    w_sgrsprt_actc_code                       activity1,
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
    w_sgrsprt_athl_aid_ind                    athletic_aid_ind1,
    w_sgrsprt_elig_code                       sport_status1,
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
    sfbetrm_ests_code                         enrollment_status,
    spbpers_confid_ind                        confidential_ind,
    --sgbstdn_styp_code                    student_population,
    --stvclas_desc                              student_classification_desc,
    nvl(i_shrlgpa.shrlgpa_hours_earned, 0)    inst_earned_hrs,
    to_char(round(nvl(i_shrlgpa.shrlgpa_gpa, 0.00),
                  2),
            'fm90D00')                        inst_gpa,
    nvl(o_shrlgpa.shrlgpa_hours_earned, 0)    overall_earned_hrs,
    to_char(round(nvl(o_shrlgpa.shrlgpa_gpa, 0.00),
                  2),
            'fm90D00')                        cumulative_gpa,
    shrtgpa_hours_earned                      term_hours,
    stvcoll_code                              college,
    maj_stvmajr.stvmajr_code                  major,
    min_stvmajr.stvmajr_code                  first_minor,
    con_stvmajr.stvmajr_code                  first_concentration,
    sfbetrm_ests_code                         enrollment_status,
    sfbetrm_ests_date                         enrollment_status_date
FROM
         sgrsprt
    JOIN w_sgrsprt ON w_sgrsprt_pidm = sgrsprt_pidm
    LEFT JOIN w_spriden ON w_spriden_pidm = sgrsprt_pidm
        
    LEFT JOIN spriden ON spriden_pidm = w_spriden_pidm
    LEFT JOIN gobtpac ON gobtpac_pidm = w_sgrsprt_pidm
    LEFT JOIN sfbetrm ON sfbetrm_pidm = w_sgrsprt_pidm
    LEFT JOIN spbpers ON spbpers_pidm = w_sgrsprt_pidm
    LEFT JOIN sorlcur ON sorlcur_pidm = w_sgrsprt_pidm
    LEFT JOIN sgbstdn ON sgbstdn_pidm = w_sgrsprt_pidm
    LEFT JOIN shrlgpa i_shrlgpa ON i_shrlgpa.shrlgpa_pidm = w_sgrsprt_pidm
                                   AND i_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                                   AND i_shrlgpa.shrlgpa_gpa_type_ind = 'I'
    LEFT JOIN shrlgpa o_shrlgpa ON o_shrlgpa.shrlgpa_pidm = w_sgrsprt_pidm
                                   AND o_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                                   AND o_shrlgpa.shrlgpa_gpa_type_ind = 'O'
    LEFT JOIN shrlgpa t_shrlgpa ON t_shrlgpa.shrlgpa_pidm = w_sgrsprt_pidm
                                   AND t_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                                   AND t_shrlgpa.shrlgpa_gpa_type_ind = 'T'
    LEFT JOIN shrtgpa ON shrtgpa_pidm = w_sgrsprt_pidm
    LEFT JOIN stvcoll ON stvcoll_code = sorlcur_coll_code
        --JOIN stvclas ON stvclas_code = sgkclas.f_class_code(sfbetrm_pidm, sgbstdn_levl_code, 202420)
    JOIN stvmajr maj_stvmajr ON maj_stvmajr.stvmajr_code = sgbstdn_majr_code_1
    LEFT JOIN stvmajr con_stvmajr ON con_stvmajr.stvmajr_code = sgbstdn_majr_code_conc_1
    LEFT JOIN stvmajr min_stvmajr ON min_stvmajr.stvmajr_code = sgbstdn_majr_code_minr_1
WHERE
    spriden_change_ind IS NULL
    AND sfbetrm_ests_code IN ('OA', 'EL')
    --AND w_sgrsprt_term_code = 202420
--    (
--        SELECT stvterm_code
--        FROM stvterm
--        WHERE sysdate BETWEEN stvterm_start_date AND stvterm_end_date
--)
;
