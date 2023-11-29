WITH w_stvterm AS (
    SELECT
        stvterm_start_date w_stvterm_start_date,
        stvterm_end_date   w_stvterm_end_date
    FROM
        stvterm
    WHERE
        stvterm_code = :main_mc_term.stvterm_code
), w_sgradvr AS (
    SELECT DISTINCT
        sgradvr_pidm                    w_sgradvr_pidm,
        MAX(sgradvr_term_code_eff)
        OVER(PARTITION BY sgradvr_pidm) w_sgradvr_term_code_eff
    FROM
        sgradvr
    WHERE
        sgradvr_term_code_eff <= :main_mc_term.stvterm_code
), w_sgbstdn AS (
    SELECT DISTINCT
        sgbstdn_pidm                    w_sgbstdn_pidm,
        MAX(sgbstdn_term_code_eff)
        OVER(PARTITION BY sgbstdn_pidm) w_sgbstdn_term_code_eff
    FROM
        sgbstdn
    WHERE
        sgbstdn_term_code_eff <= :main_mc_term.stvterm_code
), c_sfbetrm AS (
    SELECT
        sfbetrm_pidm c_sfbetrm_pidm
    FROM
        sfbetrm
    WHERE
        sfbetrm_term_code = :main_mc_term.stvterm_code
), w_sfrstcr AS (
    SELECT DISTINCT
        c_sfrstcr_pidm      w_sfrstcr_pidm,
        c_sfrstcr_crn       w_sfrstcr_crn,
        c_sfrstcr_rsts_date w_sfrstcr_rsts_date,
        sfrstcr_rsts_code   w_sfrstcr_rsts_code,
        sfrstcr_camp_code   w_sfrstcr_camp_code
    FROM
             (
            SELECT DISTINCT
                sfrstcr_pidm                                 c_sfrstcr_pidm,
                sfrstcr_crn                                  c_sfrstcr_crn,
                MAX(sfrstcr_rsts_date)
                OVER(PARTITION BY sfrstcr_pidm, sfrstcr_crn) c_sfrstcr_rsts_date
            FROM
                sfrstcr
            WHERE
                    sfrstcr_term_code = :main_mc_term.stvterm_code
                AND sfrstcr_pidm IN (
                    SELECT
                        sfbetrm_pidm
                    FROM
                        sfbetrm
                    WHERE
                        sfbetrm_term_code = :main_mc_term.stvterm_code
                )
        ) c_sftsrcr
        JOIN sfrstcr ON sfrstcr_pidm = c_sfrstcr_pidm
                        AND sfrstcr_crn = c_sfrstcr_crn
                        AND sfrstcr_rsts_date = c_sfrstcr_rsts_date
                        AND sfrstcr_rsts_code IN ( 'RE', 'RW', 'AU', 'RA', 'RF' )
), w_shrttrm AS (
    SELECT DISTINCT
        shrttrm_pidm                    w_shrttrm_pidm,
        MAX(shrttrm_term_code)
        OVER(PARTITION BY shrttrm_pidm) w_shrttrm_term_code
    FROM
        shrttrm
    WHERE
        shrttrm_term_code < :main_mc_term.stvterm_code
), w_sorlcur AS (
    SELECT DISTINCT
        sorlcur_pidm                    w_sorlcur_pidm,
        MAX(sorlcur_seqno)
        OVER(PARTITION BY sorlcur_pidm) w_sorlcur_seqno
    FROM
        sorlcur
), w_saradap AS (
    SELECT DISTINCT
        s_saradap_pidm                                               w_saradap_pidm,
        s_saradap_term_code_entry                                    w_saradap_term_code_entry,
        MAX(saradap_appl_no)
        OVER(PARTITION BY s_saradap_pidm, s_saradap_term_code_entry) w_saradap_appl_no
    FROM
             (
            SELECT
                saradap_pidm                    s_saradap_pidm,
                MAX(saradap_term_code_entry)
                OVER(PARTITION BY saradap_pidm) s_saradap_term_code_entry
            FROM
                saradap
        ) s_saradap
        JOIN saradap ON saradap_pidm = s_saradap_pidm
                        AND saradap_term_code_entry = s_saradap_term_code_entry
), m_sfbetrm AS (
    SELECT
        sfbetrm_pidm                    m_sfbetrm_pidm,
        MIN(sfbetrm_term_code)
        OVER(PARTITION BY sfbetrm_pidm) m_sfbetrm_term_code
    FROM
        sfbetrm
), w_sgbuser AS (
    SELECT
        sgbuser_pidm                    w_sgbuser_pidm,
        MAX(sgbuser_term_code)
        OVER(PARTITION BY sgbuser_pidm) w_sgbuser_term_code
    FROM
        sgbuser
    WHERE
        sgbuser_term_code <= :main_mc_term.stvterm_code
), w_sgrsprt AS (
    SELECT
        sgrsprt_pidm                    w_sgrsprt_pidm,
        MAX(sgrsprt_term_code)
        OVER(PARTITION BY sgrsprt_pidm) w_sgrsprt_term_code
    FROM
        sgrsprt
    WHERE
        sgrsprt_term_code <= :main_mc_term.stvterm_code
), w_sorhsch AS (
    SELECT DISTINCT
        sorhsch_pidm                    w_sorhsch_pidm,
        MAX(sorhsch_graduation_date)
        OVER(PARTITION BY sorhsch_pidm) w_sorhsch_graduation_date
    FROM
        sorhsch
), w_shrtrit AS (
    SELECT DISTINCT
        shrtrit_pidm                    w_shrtrit_pidm,
        MAX(shrtrit_seq_no)
        OVER(PARTITION BY shrtrit_pidm) w_shrtrit_seq_no
    FROM
        shrtrit
)
SELECT DISTINCT
    :main_mc_term.stvterm_code                 academic_period,
    s_spriden.spriden_id                      id,
    spbpers_ssn                               tax_id,
    s_spriden.spriden_last_name               last_name,
    s_spriden.spriden_first_name              first_name,
    s_spriden.spriden_mi                      middle_name,
    spbpers_name_suffix                       name_suffix,
    sfbetrm_ests_code                         enrollment_status,
    sfbetrm_ests_date                         enrollment_status_date,
    CASE
        WHEN sfbetrm_ests_code IN ( 'AW', 'OW', 'MW', 'OA', 'OC',
                                    'OD' ) THEN
            sfbetrm_ests_date
        ELSE
            NULL
    END                                       withdraw_eff_date,
    nvl(sorlcur_styp_code, sgbstdn_styp_code) student_population,
    spbpers_sex                               gender,
    sgbstdn_site_code                         site_code,
    stvcitz_desc                              citizenship_desc,
    CASE
        WHEN spbpers_citz_code = 'US' THEN
            'United States'
        ELSE
            stvnatn_nation
    END                                       nation_of_citizenship_desc,
    CASE
        WHEN (
            SELECT
                w_spraddr_stat_code
            FROM
                (
                    SELECT DISTINCT
                        spraddr_from_date    w_spraddr_from_date,
                        spraddr_atyp_code    w_spraddr_atyp_code,
                        spraddr_street_line1 w_spraddr_street_line1,
                        spraddr_stat_code    w_spraddr_stat_code
                    FROM
                        spraddr
                    WHERE
                        spraddr_street_line1 IS NOT NULL
                        AND spraddr_atyp_code IN ( 'PR', 'MA' )
                        AND spraddr_status_ind IS NULL
                        AND spraddr_pidm = sfbetrm_pidm
                    ORDER BY
                        w_spraddr_atyp_code DESC,
                        w_spraddr_from_date
                    FETCH FIRST 1 ROWS ONLY
                )
        ) = 'OK' THEN
            'In State'
        WHEN (
            SELECT
                w_spraddr_stat_code
            FROM
                (
                    SELECT DISTINCT
                        spraddr_from_date    w_spraddr_from_date, spraddr_atyp_code    w_spraddr_atyp_code, spraddr_street_line1 w_spraddr_street_line1
                        , spraddr_stat_code    w_spraddr_stat_code
                    FROM
                        spraddr
                    WHERE
                        spraddr_street_line1 IS NOT NULL
                        AND spraddr_atyp_code IN ( 'PR', 'MA' )
                        AND spraddr_status_ind IS NULL
                        AND spraddr_pidm = sfbetrm_pidm
                    ORDER BY
                        w_spraddr_atyp_code DESC, w_spraddr_from_date
                    FETCH FIRST 1 ROWS ONLY
                )
        ) IN ( 'AK', 'MO', 'TX' ) THEN
            'Quad State'
        ELSE
            'Out of State'
    END                                       residency,
    CASE
        WHEN spbpers_ethn_code = '1' THEN
            '2'
        ELSE
            NULL
    END                                       race_black,
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
    (
        SELECT
            tb2.gorprac_race_cde
        FROM
            (
                SELECT
                    g2.gorprac_pidm,
                    g2.gorprac_race_cde,
                    ROW_NUMBER()
                    OVER(PARTITION BY g2.gorprac_pidm
                         ORDER BY
                             g2.gorprac_race_cde
                    ) AS trec
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
            ) tb2
        WHERE
                tb2.gorprac_pidm = sfbetrm_pidm
            AND tb2.trec = 1
    )                                         tribe1,
    (
        SELECT
            tb2.gorprac_race_cde
        FROM
            (
                SELECT
                    g2.gorprac_pidm,
                    g2.gorprac_race_cde,
                    ROW_NUMBER()
                    OVER(PARTITION BY g2.gorprac_pidm
                         ORDER BY
                             g2.gorprac_race_cde
                    ) AS trec
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
            ) tb2
        WHERE
                tb2.gorprac_pidm = sfbetrm_pidm
            AND tb2.trec = 2
    )                                         tribe2,
    (
        SELECT
            tb2.gorprac_race_cde
        FROM
            (
                SELECT
                    g2.gorprac_pidm,
                    g2.gorprac_race_cde,
                    ROW_NUMBER()
                    OVER(PARTITION BY g2.gorprac_pidm
                         ORDER BY
                             g2.gorprac_race_cde
                    ) AS trec
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
            ) tb2
        WHERE
                tb2.gorprac_pidm = sfbetrm_pidm
            AND tb2.trec = 3
    )                                         tribe3,
    nvl(sgbuser_sude_code, '0')               tribeline,
    (
        SELECT
            stvterm_start_date
        FROM
            stvterm
        WHERE
            stvterm_code = m_sfbetrm_term_code
    )                                         first_enrolled_date,
    sgbuser_suda_code                         suda_code,
    sgbuser_sudb_code                         sudb_code,
    sgbuser_sudc_code                         sudc_code,
    sgbuser_sudd_code                         sudd_code,
    saradap_admt_code                         admit_type,
    to_char(spbpers_birth_date, 'MM/DD/YYYY') birth_date,
    TO_NUMBER(to_char(sysdate, 'YYYY')) -
    CASE
        WHEN to_char(sysdate, 'MMDD') >= to_char(spbpers_birth_date, 'MMDD') THEN
                TO_NUMBER(to_char(spbpers_birth_date, 'YYYY'))
        ELSE
            TO_NUMBER(to_char(spbpers_birth_date, 'YYYY')) - 1
    END
    current_age,
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
    shrtgpa_hours_earned                      term_hours,
    stvclas_desc                              classification,
    stvcoll_desc                              college_desc,
    ma_stvmajr.stvmajr_desc                   major_desc,
    co_stvmajr.stvmajr_desc                   first_concentration_desc,
    mi_stvmajr.stvmajr_desc                   first_minor_desc,
    sorlcur_term_code_ctlg                    catalog_term_code,
    a_spriden.spriden_last_name
    || ', '
    || a_spriden.spriden_first_name
    || ' '
    || substr(a_spriden.spriden_mi, 1, 1)
    || '.'                                    advisor,
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
        WHEN (
            SELECT
                sortest_test_score
            FROM
                sortest
            WHERE
                    sortest_pidm = sfbetrm_pidm
                AND sortest_tesc_code = 'A01'
            ORDER BY
                1
            FETCH FIRST 1 ROWS ONLY
        ) IS NOT NULL THEN
            'A01'
        ELSE
            NULL
    END                                       test1,
    (
        SELECT
            sortest_test_score
        FROM
            sortest
        WHERE
                sortest_pidm = sfbetrm_pidm
            AND sortest_tesc_code = 'A01'
        ORDER BY
            1
        FETCH FIRST 1 ROWS ONLY
    )                                         AS test_score1,
    CASE
        WHEN (
            SELECT
                sortest_test_score
            FROM
                sortest
            WHERE
                    sortest_pidm = sfbetrm_pidm
                AND sortest_tesc_code = 'A02'
            ORDER BY
                1
            FETCH FIRST 1 ROWS ONLY
        ) IS NOT NULL THEN
            'A02'
        ELSE
            NULL
    END                                       test2,
    (
        SELECT
            sortest_test_score
        FROM
            sortest
        WHERE
                sortest_pidm = sfbetrm_pidm
            AND sortest_tesc_code = 'A02'
        ORDER BY
            1
        FETCH FIRST 1 ROWS ONLY
    )                                         AS test_score2,
    CASE
        WHEN (
            SELECT
                sortest_test_score
            FROM
                sortest
            WHERE
                    sortest_pidm = sfbetrm_pidm
                AND sortest_tesc_code = 'A03'
            ORDER BY
                1
            FETCH FIRST 1 ROWS ONLY
        ) IS NOT NULL THEN
            'A03'
        ELSE
            NULL
    END                                       test3,
    (
        SELECT
            sortest_test_score
        FROM
            sortest
        WHERE
                sortest_pidm = sfbetrm_pidm
            AND sortest_tesc_code = 'A03'
        ORDER BY
            1
        FETCH FIRST 1 ROWS ONLY
    )                                         AS test_score3,
    CASE
        WHEN (
            SELECT
                sortest_test_score
            FROM
                sortest
            WHERE
                    sortest_pidm = sfbetrm_pidm
                AND sortest_tesc_code = 'A04'
            ORDER BY
                1
            FETCH FIRST 1 ROWS ONLY
        ) IS NOT NULL THEN
            'A04'
        ELSE
            NULL
    END                                       test4,
    (
        SELECT
            sortest_test_score
        FROM
            sortest
        WHERE
                sortest_pidm = sfbetrm_pidm
            AND sortest_tesc_code = 'A04'
        ORDER BY
            1
        FETCH FIRST 1 ROWS ONLY
    )                                         AS test_score4,
    CASE
        WHEN (
            SELECT
                sortest_test_score
            FROM
                sortest
            WHERE
                    sortest_pidm = sfbetrm_pidm
                AND sortest_tesc_code = 'A05'
            ORDER BY
                1
            FETCH FIRST 1 ROWS ONLY
        ) IS NOT NULL THEN
            'A05'
        ELSE
            NULL
    END                                       test5,
    (
        SELECT
            sortest_test_score
        FROM
            sortest
        WHERE
                sortest_pidm = sfbetrm_pidm
            AND sortest_tesc_code = 'A02'
        ORDER BY
            1
        FETCH FIRST 1 ROWS ONLY
    )                                         AS test_score5,
    (
        SELECT
            'Y'
        FROM
            dual
        WHERE
            EXISTS (
                SELECT
                    'x'
                FROM
                    w_sfrstcr
                WHERE
                        w_sfrstcr_pidm = sfbetrm_pidm
                    AND w_sfrstcr_camp_code = '01'
            )
    )                                         tahlequah,
    (
        SELECT
            'Y'
        FROM
            dual
        WHERE
            EXISTS (
                SELECT
                    'x'
                FROM
                    w_sfrstcr
                WHERE
                        w_sfrstcr_pidm = sfbetrm_pidm
                    AND w_sfrstcr_camp_code = '02'
            )
    )                                         muskogee,
    (
        SELECT
            'Y'
        FROM
            dual
        WHERE
            EXISTS (
                SELECT
                    'x'
                FROM
                    w_sfrstcr
                WHERE
                        w_sfrstcr_pidm = sfbetrm_pidm
                    AND w_sfrstcr_camp_code = '03'
            )
    )                                         broken_arrow,
    NULL                                      kiamichi_poteau,
    NULL                                      northeastern_ok_am_miami,
    NULL                                      ponca_city,
    NULL                                      eastern_ok_state_wilburton,
    NULL                                      connors_state_muskogee,
    NULL                                      tulsa_cc,
    spbpers_confid_ind                        confidential_ind,
    h_stvsbgi.stvsbgi_code                    hs_fice,
    h_stvsbgi.stvsbgi_desc                    high_school,
    sorhsch_graduation_date                   hs_grad_date,
    sorhsch_percentile                        hs_rank_percentile,
    sorhsch_gpa                               hs_gpa,
    ps_stvsbgi.stvsbgi_desc                   postsecondname,
    nvl2(spbpers_vera_ind, 'Y', 'N')          veteran_status,
    gobtpac_external_user || '@nsuok.edu'     nsu_email,
    lower((
        SELECT
            goremal_email_address
        FROM
            goremal
        WHERE
                goremal_emal_code = 'PERS'
            AND goremal_status_ind = 'A'
            AND goremal_pidm = sfbetrm_pidm
        ORDER BY
            goremal_activity_date DESC
        FETCH FIRST 1 ROWS ONLY
    ))                                        personal_email,
    (
        SELECT
            CASE
                WHEN s1.sprtele_phone_area IS NULL THEN
                    NULL
                WHEN s1.sprtele_phone_number IS NULL THEN
                    NULL
                ELSE
                    replace(replace(concat(s1.sprtele_phone_area, s1.sprtele_phone_number),
                                    '-'),
                            '/')
            END phone_number
        FROM
            sprtele s1
        WHERE
                s1.sprtele_pidm = sfbetrm_pidm
            AND s1.sprtele_tele_code = 'CL'
            AND s1.sprtele_status_ind IS NULL
            AND s1.sprtele_primary_ind = 'Y'
            AND length(replace(replace(concat(s1.sprtele_phone_area, s1.sprtele_phone_number),
                                       '-'),
                               '/')) BETWEEN 9 AND 12
            AND s1.sprtele_seqno = (
                SELECT
                    MAX(x1.sprtele_seqno)
                FROM
                    sprtele x1
                WHERE
                        x1.sprtele_pidm = sfbetrm_pidm
                    AND x1.sprtele_tele_code = s1.sprtele_tele_code
                    AND x1.sprtele_status_ind IS NULL
            )
    )                                         cell_phone,
    (
        SELECT
            CASE
                WHEN s1.sprtele_phone_area IS NULL THEN
                    NULL
                WHEN s1.sprtele_phone_number IS NULL THEN
                    NULL
                ELSE
                    replace(replace(concat(s1.sprtele_phone_area, s1.sprtele_phone_number),
                                    '-'),
                            '/')
            END phone_number
        FROM
            sprtele s1
        WHERE
                s1.sprtele_pidm = sfbetrm_pidm
            AND s1.sprtele_tele_code = 'PR'
            AND s1.sprtele_status_ind IS NULL
            AND s1.sprtele_primary_ind = 'Y'
            AND length(replace(replace(concat(s1.sprtele_phone_area, s1.sprtele_phone_number),
                                       '-'),
                               '/')) BETWEEN 9 AND 12
            AND s1.sprtele_seqno = (
                SELECT
                    MAX(x1.sprtele_seqno)
                FROM
                    sprtele x1
                WHERE
                        x1.sprtele_pidm = sfbetrm_pidm
                    AND x1.sprtele_tele_code = s1.sprtele_tele_code
                    AND x1.sprtele_status_ind IS NULL
            )
    )                                         current_phone,
    (
        SELECT
            CASE
                WHEN s1.sprtele_phone_area IS NULL THEN
                    NULL
                WHEN s1.sprtele_phone_number IS NULL THEN
                    NULL
                ELSE
                    replace(replace(concat(s1.sprtele_phone_area, s1.sprtele_phone_number),
                                    '-'),
                            '/')
            END phone_number
        FROM
            sprtele s1
        WHERE
                s1.sprtele_pidm = sfbetrm_pidm
            AND s1.sprtele_tele_code = 'CL'
            AND s1.sprtele_status_ind IS NULL
            AND s1.sprtele_primary_ind = 'Y'
            AND length(replace(replace(concat(s1.sprtele_phone_area, s1.sprtele_phone_number),
                                       '-'),
                               '/')) BETWEEN 9 AND 12
            AND s1.sprtele_seqno = (
                SELECT
                    MAX(x1.sprtele_seqno)
                FROM
                    sprtele x1
                WHERE
                        x1.sprtele_pidm = sfbetrm_pidm
                    AND x1.sprtele_tele_code = s1.sprtele_tele_code
                    AND x1.sprtele_status_ind IS NULL
            )
    )                                         permanent_phone,
    (
        SELECT
            w_spraddr_street_line1
            || '|'
            || w_spraddr_street_line1
            || '|'
            || w_spraddr_city
            || '|'
            || w_spraddr_stat_code
            || '|'
            || w_spraddr_zip
            || '|'
            || w_spraddr_natn_code
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_street_line2 w_spraddr_street_line2,
                    spraddr_city         w_spraddr_city,
                    spraddr_stat_code    w_spraddr_stat_code,
                    spraddr_zip          w_spraddr_zip,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'PR' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = sfbetrm_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         permanent_address,
    (
        SELECT
            w_spraddr_street_line1
            || '|'
            || w_spraddr_street_line1
            || '|'
            || w_spraddr_city
            || '|'
            || w_spraddr_stat_code
            || '|'
            || w_spraddr_zip
            || '|'
            || w_spraddr_natn_code
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_street_line2 w_spraddr_street_line2,
                    spraddr_city         w_spraddr_city,
                    spraddr_stat_code    w_spraddr_stat_code,
                    spraddr_zip          w_spraddr_zip,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'MA' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = sfbetrm_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         mailing_address
FROM
         sfbetrm
    JOIN spriden s_spriden ON sfbetrm_pidm = s_spriden.spriden_pidm
                              AND s_spriden.spriden_change_ind IS NULL
    JOIN w_sgbstdn ON w_sgbstdn_pidm = sfbetrm_pidm
    JOIN sgbstdn ON sgbstdn_pidm = w_sgbstdn_pidm
                    AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
                    AND sgbstdn_stst_code NOT IN ( 'IS', 'IG' )
    JOIN stvmajr ma_stvmajr ON ma_stvmajr.stvmajr_code = sgbstdn_majr_code_1
    LEFT JOIN stvmajr co_stvmajr ON co_stvmajr.stvmajr_code = sgbstdn_majr_code_conc_1
    LEFT JOIN stvmajr mi_stvmajr ON mi_stvmajr.stvmajr_code = sgbstdn_majr_code_minr_1
    JOIN w_sgradvr ON w_sgradvr_pidm = sfbetrm_pidm
    JOIN sgradvr ON sgradvr_pidm = w_sgradvr_pidm
                    AND sgradvr_term_code_eff = w_sgradvr_term_code_eff
                    AND sgradvr_prim_ind = 'Y'
    JOIN spriden a_spriden ON a_spriden.spriden_pidm = sgradvr_advr_pidm
                              AND a_spriden.spriden_change_ind IS NULL
    LEFT JOIN w_shrttrm ON w_shrttrm_pidm = sfbetrm_pidm
    LEFT JOIN shrttrm ON shrttrm_pidm = w_shrttrm_pidm
                         AND shrttrm_term_code = w_shrttrm_term_code
    JOIN stvclas ON stvclas_code = sgkclas.f_class_code(sfbetrm_pidm, sgbstdn_levl_code, :main_mc_term.stvterm_code)
    LEFT JOIN stvastd ON stvastd_code = shrttrm_astd_code_end_of_term
    LEFT JOIN shrlgpa i_shrlgpa ON i_shrlgpa.shrlgpa_pidm = sfbetrm_pidm
                                   AND i_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                                   AND i_shrlgpa.shrlgpa_gpa_type_ind = 'I'
    LEFT JOIN shrlgpa o_shrlgpa ON o_shrlgpa.shrlgpa_pidm = sfbetrm_pidm
                                   AND o_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                                   AND o_shrlgpa.shrlgpa_gpa_type_ind = 'O'
    LEFT JOIN shrlgpa t_shrlgpa ON t_shrlgpa.shrlgpa_pidm = sfbetrm_pidm
                                   AND t_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
                                   AND t_shrlgpa.shrlgpa_gpa_type_ind = 'T'
    JOIN gobtpac ON gobtpac_pidm = sfbetrm_pidm
    JOIN w_sorlcur ON w_sorlcur_pidm = sfbetrm_pidm
    JOIN sorlcur ON sorlcur_pidm = w_sorlcur_pidm
                    AND sorlcur_seqno = w_sorlcur_seqno
    LEFT JOIN stvcoll ON sorlcur_coll_code = stvcoll_code
    JOIN w_saradap ON w_saradap_pidm = sfbetrm_pidm
    JOIN saradap ON saradap_pidm = w_saradap_pidm
                    AND saradap_term_code_entry = w_saradap_term_code_entry
                    AND saradap_appl_no = w_saradap_appl_no
    JOIN spbpers ON spbpers_pidm = sfbetrm_pidm
    LEFT JOIN stvcitz ON stvcitz_code = spbpers_citz_code
    LEFT JOIN gobintl ON gobintl_pidm = sfbetrm_pidm
    LEFT JOIN stvnatn ON gobintl_natn_code_legal = stvnatn_code
    JOIN m_sfbetrm ON m_sfbetrm_pidm = sfbetrm_pidm
    LEFT JOIN w_sgbuser ON w_sgbuser_pidm = sfbetrm_pidm
    LEFT JOIN sgbuser ON sgbuser_pidm = w_sgbuser_pidm
                         AND w_sgbuser_term_code = sgbuser_term_code
    LEFT JOIN shrtgpa ON shrtgpa_pidm = sfbetrm_pidm
                         AND shrtgpa_term_code = :main_mc_term.stvterm_code
    LEFT JOIN w_sgrsprt ON w_sgrsprt_pidm = sfbetrm_pidm
    LEFT JOIN sgrsprt ON sgrsprt_pidm = w_sgrsprt_pidm
                         AND w_sgrsprt_term_code = sgrsprt_term_code
    LEFT JOIN w_sfrstcr ON w_sfrstcr_pidm = sfbetrm_pidm
    LEFT JOIN w_sorhsch ON sfbetrm_pidm = w_sorhsch_pidm
    LEFT JOIN sorhsch ON sorhsch_pidm = w_sorhsch_pidm
                         AND sorhsch_graduation_date = w_sorhsch_graduation_date
                         AND sorhsch_gpa IS NOT NULL
    LEFT JOIN stvsbgi h_stvsbgi ON h_stvsbgi.stvsbgi_code = sorhsch_sbgi_code
    LEFT JOIN w_shrtrit ON w_shrtrit_pidm = sfbetrm_pidm
    LEFT JOIN shrtrit ON shrtrit_pidm = w_shrtrit_pidm
                         AND w_shrtrit_seq_no = shrtrit_seq_no
    LEFT JOIN stvsbgi ps_stvsbgi ON ps_stvsbgi.stvsbgi_code = shrtrit_sbgi_code
WHERE
    sfbetrm_term_code = :main_mc_term.stvterm_code
    AND sfbetrm_ests_code = :main_mc_ests.enrollment_status
ORDER BY
    3,
    4
