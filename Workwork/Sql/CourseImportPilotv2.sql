-- Original version by Jonathan Petruska
-- Union update 10-30-2023 by Gabriel Berres
WITH w_pebempl AS (
    SELECT
        pebempl_pidm      AS w_pebempl_pidm,
        pebempl_camp_code AS w_pebempl_camp_code,
        pebempl_ecls_code AS w_pebempl_ecls_code
    FROM
        pebempl
        LEFT JOIN nbrjobs ON nbrjobs_pidm = pebempl_pidm
    WHERE
        pebempl_ecls_code NOT IN ( '99', '90', '93' )
        AND pebempl_empl_status <> 'T'
        AND ( ( pebempl_last_work_date IS NULL )
              OR ( pebempl_last_work_date >= CASE
                                                 WHEN pebempl_ecls_code NOT IN ( '80', '81', '99', '73', '70',
                                                                                 '34', '35', '82', '83', '85',
                                                                                 '71', '72', '73' ) THEN
                                                     :main_lb_terms.stvterm_end_date - 730
                                                 ELSE
                                                     :main_lb_terms.stvterm_end_date
                                             END ) )
        AND nbrjobs_jcre_code <> 'RETR'
        AND nbrjobs_status <> 'T'
        AND nbrjobs_ecls_code NOT IN ( '90', '92' )
), s_spriden AS (
    SELECT DISTINCT
        sfbetrm_pidm AS s_spriden_pidm
    FROM
        sfbetrm
    WHERE
        sfbetrm_term_code = :main_lb_terms.stvterm_code
), t_saradap AS (
    SELECT DISTINCT
        MIN(saradap_term_code_entry)
        OVER(PARTITION BY saradap_pidm) AS t_saradap_term_code_entry,
        saradap_pidm                    AS t_saradap_pidm
    FROM
        saradap
    WHERE
        saradap_admt_code NOT IN ( '6A', '6B', '6C', '6D', '6E',
                                   '6F' )
        AND saradap_apst_code NOT IN ( 'A' )
        AND saradap_term_code_entry <= :main_lb_terms.stvterm_code
), t_sgbstdn AS (
    SELECT
        sgbstdn_pidm                    AS t_sgbstdn_pidm,
        MAX(sgbstdn_term_code_eff)
        OVER(PARTITION BY sgbstdn_pidm) AS t_sgbstdn_term_code_eff
    FROM
        sgbstdn
    WHERE
        sgbstdn_term_code_eff <= :main_lb_terms.stvterm_code
)
-- Begin Union
SELECT
    'User ID'           User_ID,
    'Firstname'         Firstname,
    'Middlename'        Middlename,
    'Lastname'          Lastname,
    'Gender'            Gender,
    'Email'             Email,
    'Role'              Role,
    'Password'          Password,
    'Major'             Major,
    'Race/Ethnicity'    Race_Ethnicity,
    'Race Details'      Race_Details,
    'Transfer Student'  Transfer_Student,
    'Pell Eligibility'  Pell_Eligibility,
    'Year of Admission' Year_Of_Admission,
    'Class'             Class,
    'Academic Program'  Academic_Program,
    'SSO UID'           SSO_UID1,
    'SAT'               SAT,
    'ACT'               ACT,
    'GRE'               GRE,
    'MCAT'              MCAT,
    'GMAT'              GMAT,
    'LSAT'              LSAT
FROM
    dual
UNION ALL

-- Resume previous report
SELECT DISTINCT
    spriden_id                            AS "User_ID",
    CASE
        WHEN spbpers_pref_first_name IS NOT NULL THEN
            spbpers_pref_first_name
        ELSE
            spriden_first_name
    END                                   AS "Firstname",
    spriden_mi                            AS "Middlename",
    spriden_last_name                     AS "Lastname",
    CASE
        WHEN spbpers_sex = 'F' THEN
            'Female'
        WHEN spbpers_sex = 'M' THEN
            'Male'
        ELSE
            'Not Specified'
    END                                   AS "Gender",
    gobtpac_external_user || '@nsuok.edu' AS "Email",
    CASE
        WHEN w_pebempl_pidm IS NOT NULL THEN
                CASE
                    WHEN w_pebempl_pidm IN ('2052',    -- Cari Keller
                                            '202132',  -- Karrine Ortiz
                                            '197936',  -- Lori Riley
                                            '119733',  -- Pam Fly
                                            '127235',  -- Lisa Czlonka
                                            '2168'     -- Rob Moruzzi
                                              ) THEN
                        'admin'
                    ELSE
                        'faculty'
                END
        ELSE
            'student'
    END                                   AS "Role",
    'Password'                            AS "Password",
    stvmajr_desc                          AS "Major",
    CASE
        WHEN spbpers_ethn_code = 1 THEN
            'Non-Resident Alien'
        WHEN spbpers_ethn_code = 2 THEN
            'Black or African American'
        WHEN spbpers_ethn_code = 3 THEN
            'American Indian or Alaskan Native'
        WHEN spbpers_ethn_code = 4 THEN
            'Asian'
        WHEN spbpers_ethn_code = 5 THEN
            'Hispanic or Latino'
        WHEN spbpers_ethn_code = 6 THEN
            'White'
        WHEN spbpers_ethn_code = 7 THEN
            'Native Hawaiian or other Pacific Islander'
        WHEN spbpers_ethn_code = 8 THEN
            'Not Specified / Declined to Specify'
        ELSE
            'Not Specified / Declined to Specify'
    END                                   AS "Race_Ethnicity",
    CASE
        WHEN spbpers_ethn_code = 1 THEN
            'Other'
        WHEN spbpers_ethn_code = 2 THEN
            'Black Non-Hispanic'
        WHEN spbpers_ethn_code = 3 THEN
            'Am. Indian or Alaskan Native'
        WHEN spbpers_ethn_code = 4 THEN
            'Asian or Pacific Islander'
        WHEN spbpers_ethn_code = 5 THEN
            'Hispanic'
        WHEN spbpers_ethn_code = 6 THEN
            'White Non-Hispanic'
        WHEN spbpers_ethn_code = 7 THEN
            'Asian or Pacific Islander'
        WHEN spbpers_ethn_code = 8 THEN
            'Other'
        ELSE
            'Other'
    END                                   AS "Race_Details",
    CASE
        WHEN saradap_admt_code IN ( '7E', '1B', '1E', '2B', '2E',
                                    '3B', '3E' ) THEN
            'Y'
        ELSE
            'N'
    END                                   AS "Transfer_Student",
    CASE
        WHEN rorstat_pell_sched_awd <> 0 THEN
            'Y'
        WHEN rorstat_pell_sched_awd IS NOT NULL THEN
            'Y'
        ELSE
            'N'
    END                                   AS "Pell_Eligibility",
    CASE
        WHEN s_spriden_pidm IS NOT NULL THEN
            to_char(stvterm_start_date, 'YYYY')
        ELSE
            NULL
    END                                   AS "Year_Of_Admission",
    stvclas_desc                          AS "Class",
    smrprle_program_desc                  AS "Academic_Program",
    gobtpac_external_user                 AS "SSO_UIDl",
    TO_CHAR((
        SELECT
            sortest_test_score
        FROM
            sortest
        WHERE
                sortest_pidm = s_spriden_pidm
            AND sortest_tesc_code = 'S10'
        ORDER BY
            1
        FETCH FIRST 1 ROWS ONLY
    ))                                     AS "SAT",
    TO_CHAR((
        SELECT
            sortest_test_score
        FROM
            sortest
        WHERE
                sortest_pidm = s_spriden_pidm
            AND sortest_tesc_code = 'A05'
        ORDER BY
            1
        FETCH FIRST 1 ROWS ONLY
    ))                                     AS "ACT",
    TO_CHAR((
        SELECT
            sortest_test_score
        FROM
            sortest
        WHERE
                sortest_pidm = s_spriden_pidm
            AND sortest_tesc_code = 'GR01'
        ORDER BY
            1
        FETCH FIRST 1 ROWS ONLY
    ) + (
        SELECT
            sortest_test_score
        FROM
            sortest
        WHERE
                sortest_pidm = s_spriden_pidm
            AND sortest_tesc_code = 'GR02'
        ORDER BY
            1
        FETCH FIRST 1 ROWS ONLY
    ))                                     AS "GRE",
    TO_CHAR((
        SELECT
            sortest_test_score
        FROM
            sortest
        WHERE
                sortest_pidm = s_spriden_pidm
            AND sortest_tesc_code = 'MTOT'
        ORDER BY
            1
        FETCH FIRST 1 ROWS ONLY
    ))                                     AS "MCAT",
    TO_CHAR((
        SELECT
            sortest_test_score
        FROM
            sortest
        WHERE
                sortest_pidm = s_spriden_pidm
            AND sortest_tesc_code = 'G05'
        ORDER BY
            1
        FETCH FIRST 1 ROWS ONLY
    ))                                     AS "GMAT",
    TO_CHAR((
        SELECT
            sortest_test_score
        FROM
            sortest
        WHERE
                sortest_pidm = s_spriden_pidm
            AND sortest_tesc_code = 'LSAT'
        ORDER BY
            1
        FETCH FIRST 1 ROWS ONLY
    ))                                     AS "LSAT"
FROM
    spriden
    LEFT JOIN s_spriden ON s_spriden_pidm = spriden_pidm
    LEFT JOIN w_pebempl ON w_pebempl_pidm = spriden_pidm
    JOIN spbpers ON spbpers_pidm = spriden_pidm
    LEFT JOIN t_saradap ON t_saradap_pidm = spriden_pidm
    LEFT JOIN stvterm ON stvterm_code = t_saradap_term_code_entry
    LEFT JOIN saradap ON saradap_pidm = t_saradap_pidm
                         AND saradap_term_code_entry = t_saradap_term_code_entry
                         AND s_spriden_pidm IS NOT NULL
    LEFT JOIN t_sgbstdn ON t_sgbstdn_pidm = spriden_pidm
    LEFT JOIN sgbstdn ON sgbstdn_pidm = t_sgbstdn_pidm
                         AND sgbstdn_term_code_eff = t_sgbstdn_term_code_eff
                         AND s_spriden_pidm IS NOT NULL
    LEFT JOIN stvmajr ON stvmajr_code = sgbstdn_majr_code_1
                         AND s_spriden_pidm IS NOT NULL
    JOIN gobtpac ON gobtpac_pidm = spriden_pidm
    LEFT JOIN smrprle ON smrprle_program = sgbstdn_program_1
    LEFT JOIN stvclas ON stvclas_code = sgkclas.f_class_code(s_spriden_pidm, sgbstdn_levl_code, :main_sql_term.stvterm_code)
    LEFT JOIN rorstat ON rorstat_pidm = s_spriden_pidm
                         AND rorstat_aidy_code = :main_sql_aidy.rovaidy_aidy_code
WHERE
    spriden_change_ind IS NULL
    AND ( s_spriden_pidm IS NOT NULL
          OR w_pebempl_pidm IS NOT NULL )
    AND :main_btn_go > 0
UNION ALL
SELECT
    'N00000000',
    'PLACE',
    'PLACEHOLDER',
    'HOLDER',
    'Not Specified',
    'placeholder@nsuok.edu',
    'faculty',
    'Password',
    NULL,
    'Not Specified / Declined to Specify',
    'Not Specified / Declined to Specify',
    'N',
    'N',
    NULL,
    NULL,
    NULL,
    'placeholder',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
FROM
    dual
WHERE
    :main_btn_go > 0
