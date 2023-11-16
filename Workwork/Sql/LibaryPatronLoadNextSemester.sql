WITH w_sgbstdn AS (
    SELECT DISTINCT
        MAX(sgbstdn_term_code_eff)
        OVER(PARTITION BY sgbstdn_pidm) AS w_sgbstdn_term_code_eff,
        sgbstdn_pidm                    AS w_sgbstdn_pidm
    FROM
        sgbstdn
), w_pebempl AS (
    SELECT DISTINCT
        pebempl_pidm      AS w_pebempl_pidm,
        pebempl_ecls_code AS w_pebempl_ecls_code
    FROM
        pebempl
        LEFT JOIN nbrjobs ON nbrjobs_pidm = pebempl_pidm
    WHERE
        pebempl_ecls_code NOT IN ( '80', '81', '99', '73', '70',
                                   '34', '35', '82', '85', '71',
                                   '72', '73' )
        AND pebempl_empl_status <> 'T'
        AND ( ( pebempl_last_work_date IS NULL )
              OR ( pebempl_last_work_date >= sysdate ) )
        AND nbrjobs_jcre_code <> 'RETR'
        AND nbrjobs_status <> 'T'
        AND nbrjobs_ecls_code NOT IN ( '80', '81', '90', '92' )
), w_sfrstcr AS (
    SELECT DISTINCT
        MAX(sfrstcr_rsts_date)
        OVER(PARTITION BY sfrstcr_pidm, sfrstcr_term_code, sfrstcr_crn) AS w_sfrstcr_rsts_date,
        sfrstcr_pidm                                                    AS w_sfrstcr_pidm,
        sfrstcr_crn                                                     AS w_sfrstcr_crn,
        sfrstcr_term_code                                               AS w_sfrstcr_term_code
    FROM
        sfrstcr
    WHERE
            sfrstcr_term_code = (
                SELECT
                    CASE
                        WHEN substr(stvterm_code, 5, 2) IN ( '10', '20' ) THEN
                            substr(stvterm_code, 1, 4)
                            || to_char(TO_NUMBER(substr(stvterm_code, 5, 2)) + 10)
                        WHEN substr(stvterm_code, 5, 2) = '30' THEN
                            to_char(TO_NUMBER(substr(stvterm_code, 1, 4)) + 1)
                            || '10'
                    END next_stvterm_code
                FROM
                    stvterm
                WHERE
                    sysdate BETWEEN stvterm_start_date AND stvterm_end_date
                    AND substr(stvterm_code, 5, 2) IN ( '10', '20', '30' )
            )
        AND sfrstcr_rsts_code IN ( 'RE', 'RW', 'AU' )
), w_sprtele AS (
    SELECT
        spriden_pidm w_sprtele_pidm,
        CASE
            WHEN pr_number.sprtele_phone_area IS NULL THEN
                NULL
            WHEN pr_number.sprtele_phone_number IS NULL THEN
                NULL
            WHEN replace(replace(concat(pr_number.sprtele_phone_area, pr_number.sprtele_phone_number),
                                 '-'),
                         '/') IS NULL THEN
                replace(replace(concat(cl_number.sprtele_phone_area, cl_number.sprtele_phone_number),
                                '-'),
                        '/')
            ELSE
                replace(replace(concat(pr_number.sprtele_phone_area, pr_number.sprtele_phone_number),
                                '-'),
                        '/')
        END          w_sprtele_phone_number
    FROM
        spriden
        LEFT JOIN (
            SELECT
                s1.sprtele_pidm,
                s1.sprtele_phone_area,
                s1.sprtele_phone_number
            FROM
                sprtele s1
            WHERE
                    s1.sprtele_tele_code = 'PR'
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
                            x1.sprtele_pidm = s1.sprtele_pidm
                        AND x1.sprtele_tele_code = s1.sprtele_tele_code
                        AND x1.sprtele_status_ind IS NULL
                )
        ) pr_number ON pr_number.sprtele_pidm = spriden_pidm
        LEFT JOIN (
            SELECT
                s1.sprtele_pidm,
                s1.sprtele_phone_area,
                s1.sprtele_phone_number
            FROM
                sprtele s1
            WHERE
                    s1.sprtele_tele_code = 'CL'
                AND s1.sprtele_status_ind IS NULL
                AND length(replace(replace(concat(s1.sprtele_phone_area, s1.sprtele_phone_number),
                                           '-'),
                                   '/')) BETWEEN 9 AND 12
                AND s1.sprtele_seqno = (
                    SELECT
                        MAX(y1.sprtele_seqno)
                    FROM
                        sprtele y1
                    WHERE
                            y1.sprtele_pidm = s1.sprtele_pidm
                        AND y1.sprtele_tele_code = s1.sprtele_tele_code
                        AND y1.sprtele_status_ind IS NULL
                )
        ) cl_number ON cl_number.sprtele_pidm = spriden_pidm
    WHERE
        spriden_change_ind IS NULL
)
SELECT DISTINCT
    ''                                        AS prefix,
    spriden_first_name                        AS givenname,
    spriden_mi                                AS middlename,
    spriden_last_name                         AS familyname,
    spbpers_name_suffix                       AS suffix,
    ''                                        AS nickname,
    ''                                        AS canselfedit,
    ''                                        AS dateofbirth,
    ''                                        AS gender,
    '2377'                                    AS institutionid,
    8
    || substr(spriden_id, 2, 8)               barcode,
    upper(gobtpac_external_user)              AS idatasource,
    'https://myqlidp.nsuok.edu'               sourcesystem,
    CASE
        WHEN pebempl_pidm IS NOT NULL THEN
            'Faculty/Staff'
        WHEN sgbstdn_levl_code = 'UG' THEN
            'Undergraduate'
        WHEN sgbstdn_levl_code = 'GR' THEN
            'Graduate'
        WHEN sgbstdn_levl_code = 'PR' THEN
            'Graduate'
        ELSE
            ''
    END                                       AS borrowercategory,
    to_char(sysdate, 'YYYY-MM-DD"T"HH:MM:SS') AS circregistrationdate,
    '195680'                                  homebranch,
    (
        SELECT
            w_spraddr_street_line1
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'PR' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = spriden_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         AS primarystreetaddressline1,
    (
        SELECT
            w_spraddr_street_line2
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_street_line2 w_spraddr_street_line2,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'PR' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = spriden_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         AS primarystreetaddressline2,
    (
        SELECT
            w_spraddr_city
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_city         w_spraddr_city,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'PR', 'MA' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = spriden_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         AS primarycityorlocality,
    (
        SELECT
            w_spraddr_stat_code
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_stat_code    w_spraddr_stat_code,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'PR' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = spriden_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         AS primarystateorprovince,
    (
        SELECT
            w_spraddr_zip
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_zip          w_spraddr_zip,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'PR' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = spriden_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         AS primarypostalcode,
    (
        SELECT
            w_spraddr_natn_code
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_zip          w_spraddr_zip,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'PR' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = spriden_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         AS primarycountry,
    w_sprtele_phone_number                    AS primaryphone,
    (
        SELECT
            w_spraddr_street_line1
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'MA' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = spriden_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         AS secondarystreetaddressline1,
    (
        SELECT
            w_spraddr_street_line2
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_street_line2 w_spraddr_street_line2,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'MA' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = spriden_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         AS secondarystreetaddressline2,
    (
        SELECT
            w_spraddr_city
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_city         w_spraddr_city,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'MA' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = spriden_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         AS secondarycityorlocality,
    (
        SELECT
            w_spraddr_stat_code
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_stat_code    w_spraddr_stat_code,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'MA' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = spriden_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         AS secondarystateorprovince,
    (
        SELECT
            w_spraddr_zip
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_zip          w_spraddr_zip,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'MA' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = spriden_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         AS secondarypostalcode,
    (
        SELECT
            w_spraddr_natn_code
        FROM
            (
                SELECT DISTINCT
                    spraddr_from_date    w_spraddr_from_date,
                    spraddr_atyp_code    w_spraddr_atyp_code,
                    spraddr_street_line1 w_spraddr_street_line1,
                    spraddr_zip          w_spraddr_zip,
                    spraddr_natn_code    w_spraddr_natn_code
                FROM
                    spraddr
                WHERE
                    spraddr_street_line1 IS NOT NULL
                    AND spraddr_atyp_code IN ( 'MA' )
                    AND spraddr_status_ind IS NULL
                    AND spraddr_pidm = spriden_pidm
                ORDER BY
                    w_spraddr_atyp_code DESC,
                    w_spraddr_from_date
                FETCH FIRST 1 ROWS ONLY
            )
    )                                         AS secondarycountry,
    w_sprtele_phone_number                    AS primaryphone,
    ''                                        notificationemail,
    ''                                        notificationtextphone,
    ''                                        patronnotes,
    ''                                        photourl,
    ''                                        customdata1,
    ''                                        customdata2,
    ''                                        customdata3,
    ''                                        customdata4,
    ''                                        username,
    8
    || substr(spriden_id, 2, 8)               illid,
    ''                                        illapprovalstatus,
    CASE
        WHEN w_pebempl_pidm IS NOT NULL THEN
            'Faculty/Staff'
        WHEN sgbstdn_levl_code = 'UG' THEN
            'Undergraduate'
        WHEN sgbstdn_levl_code = 'GR' THEN
            'Graduate'
        WHEN sgbstdn_levl_code = 'PR' THEN
            'Graduate'
        ELSE
            ''
    END                                       AS illpatrontype,
    ''                                        illpickuplocation
FROM
    spriden
    LEFT JOIN spbpers ON spbpers_pidm = spriden_pidm
    LEFT JOIN w_sgbstdn ON w_sgbstdn_pidm = spriden_pidm
    LEFT JOIN sgbstdn ON sgbstdn_pidm = w_sgbstdn_pidm
                         AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
    LEFT JOIN gobtpac ON gobtpac_pidm = spriden_pidm
    LEFT JOIN pebempl ON pebempl_pidm = spriden_pidm
    LEFT JOIN w_pebempl ON w_pebempl_pidm = spriden_pidm
    LEFT JOIN w_sfrstcr ON w_sfrstcr_pidm = spriden_pidm
    LEFT JOIN w_sprtele ON w_sprtele_pidm = spriden_pidm
WHERE
    spriden_change_ind IS NULL
    AND ( w_pebempl_pidm IS NOT NULL
          OR w_sfrstcr_pidm IS NOT NULL )
ORDER BY
    4,
    2
;
