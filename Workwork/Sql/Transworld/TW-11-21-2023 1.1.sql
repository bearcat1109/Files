
-- GORVISA and LAST_TERM_CHARGED update 11-7-2023 Gabriel B, Jason T, Jonathan P
-- pr_inactive_only, ma_inactive_only, bd_exists Update 11-14-2023 Jonathan Petruska, Gabriel Berres
-- IS_CONCURRENT saradap update 11-16-2023 Gabriel Berres
-- RE-removed LAST_TERM_CHARGED and replaced LAST_Attend_Term
-- Added IS_Sub50 Ind and also moved current enrollment into the WHERE clause, 11-21-2023 Team

WITH w_spriden AS (
    SELECT
        spriden_pidm,
        spriden_id,
        spriden_last_name,
        spriden_first_name
    FROM
        (
            SELECT
                spriden_pidm,
                spriden_id,
                spriden_last_name,
                spriden_first_name
            FROM
                spriden
            WHERE
                EXISTS (
                    SELECT
                        'x'
                    FROM
                        sprhold
                    WHERE
                            sprhold_hldd_code = '61'
                        AND sysdate BETWEEN sprhold_from_date AND nvl(sprhold_to_date, sysdate + 1)
                        AND sprhold_release_ind = 'N'
                        AND sprhold_pidm = spriden_pidm
                )
                AND spriden_change_ind IS NULL
                AND spriden_entity_ind = 'P'
                AND spriden_id LIKE 'N________'
        )
    WHERE
        spriden_last_name NOT LIKE '%DO%NOT%USE%'
), w_tbraccd AS (
    SELECT
        tbraccd_pidm,
        SUM(tbraccd_balance) tbraccd_balance
    FROM
        tbraccd
    GROUP BY
        tbraccd_pidm
), w_tbraccd_charge AS
(
    SELECT DISTINCT
        tbraccd_pidm w_tbraccd_charge_pidm,
        MAX(tbraccd_term_code) OVER (PARTITION BY(tbraccd_pidm)) w_tbraccd_charge_max_term
    FROM
        tbraccd
    JOIN tbbdetc ON tbbdetc_detail_code = tbraccd_detail_code
                AND tbbdetc_type_ind = 'C'
), w_spbpers AS (
    SELECT
        spbpers_pidm,
        spbpers_birth_date,
        spbpers_ssn,
        spbpers_pref_first_name
    FROM
        spbpers
), w_spraddr_pr AS (
    SELECT
        spraddr_pidm,
        MAX(spraddr_street_line1) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC) spraddr_street_line1,
        MAX(spraddr_street_line2) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC) spraddr_street_line2,
        MAX(spraddr_city) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC)         spraddr_city,
        MAX(spraddr_stat_code) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC)    spraddr_stat_code,
        MAX(spraddr_zip) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC)          spraddr_zip
    FROM
        spraddr
    WHERE
        sysdate BETWEEN spraddr_from_date AND nvl(spraddr_to_date, sysdate + 1)
        AND spraddr_status_ind IS NULL
        AND nvl(spraddr_natn_code, 'US') = 'US'
        AND spraddr_atyp_code = 'PR'
    GROUP BY
        spraddr_pidm
), w_spraddr_ma AS (
    SELECT
        spraddr_pidm,
        MAX(spraddr_street_line1) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC) spraddr_street_line1,
        MAX(spraddr_street_line2) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC) spraddr_street_line2,
        MAX(spraddr_city) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC)         spraddr_city,
        MAX(spraddr_stat_code) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC)    spraddr_stat_code,
        MAX(spraddr_zip) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC)          spraddr_zip
    FROM
        spraddr
    WHERE
        sysdate BETWEEN spraddr_from_date AND nvl(spraddr_to_date, sysdate + 1)
        AND spraddr_status_ind IS NULL
        AND nvl(spraddr_natn_code, 'US') = 'US'
        AND spraddr_atyp_code = 'MA'
    GROUP BY
        spraddr_pidm
), w_spraddr_bd AS (
    SELECT
        spraddr_pidm,
        MAX(spraddr_street_line1) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC) spraddr_street_line1,
        MAX(spraddr_street_line2) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC) spraddr_street_line2,
        MAX(spraddr_city) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC)         spraddr_city,
        MAX(spraddr_stat_code) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC)    spraddr_stat_code,
        MAX(spraddr_zip) KEEP(DENSE_RANK FIRST ORDER BY spraddr_seqno DESC)          spraddr_zip
    FROM
        spraddr
    WHERE
        sysdate BETWEEN spraddr_from_date AND nvl(spraddr_to_date, sysdate + 1)
        AND spraddr_status_ind IS NULL
        AND nvl(spraddr_natn_code, 'US') = 'US'
        AND spraddr_atyp_code = 'BD'
    GROUP BY
        spraddr_pidm
), w_gorvisa AS (
    SELECT
        gorvisa_pidm
    FROM
        gorvisa
    WHERE
        gorvisa_vtyp_code IN ('F1', 'J1')
), w_sgbstdn AS (
    SELECT
        sgbstdn_pidm
    FROM
        sgbstdn
    WHERE
        sgbstdn_styp_code = 'L'
), w_sfrstcr AS (
    SELECT DISTINCT
        c_sfrstcr_pidm      w_sfrstcr_pidm,
        c_sfrstcr_crn       w_sfrstcr_crn,
        c_sfrstcr_rsts_date w_sfrstcr_rsts_date,
        sfrstcr_rsts_code   w_sfrstcr_rsts_code,
        c_sfrstcr_term_code   w_sfrstcr_term_code
    FROM
             (
            SELECT DISTINCT
                sfrstcr_pidm                                 c_sfrstcr_pidm,
                sfrstcr_crn                                  c_sfrstcr_crn,
                sfrstcr_term_code                            c_sfrstcr_term_code,
                MAX(sfrstcr_rsts_date)
                OVER(PARTITION BY sfrstcr_pidm, sfrstcr_crn, sfrstcr_term_code) c_sfrstcr_rsts_date
            FROM
                sfrstcr

        ) c_sftsrcr
        JOIN sfrstcr ON sfrstcr_pidm = c_sfrstcr_pidm
                        AND sfrstcr_crn = c_sfrstcr_crn
                        AND sfrstcr_rsts_date = c_sfrstcr_rsts_date
    WHERE
        sfrstcr_rsts_code IN ( 'RE', 'RW', 'AU', 'RA', 'RF' )
), w_sfrstcr_max AS
(
    SELECT DISTINCT
        w_sfrstcr_pidm      w_sfrstcr_max_pidm,
    MAX(w_sfrstcr_term_code)
    OVER (PARTITION BY w_sfrstcr_pidm)  w_sfrstcr_max_term_code
    FROM
        w_sfrstcr
), w_pebempl AS (
    SELECT DISTINCT
        pebempl_pidm
    FROM
        pebempl
        LEFT JOIN nbrjobs ON nbrjobs_pidm = pebempl_pidm
    WHERE
        pebempl_ecls_code NOT IN ( '80', '81', '99', '73', '70',
                                   '34', '35', '82', '83', '85',
                                   '71', '72', '73' )
        AND pebempl_empl_status <> 'T'
        AND ( ( pebempl_last_work_date IS NULL )
              OR ( pebempl_last_work_date >= sysdate ) )
        AND nbrjobs_jcre_code <> 'RETR'
        AND nbrjobs_status <> 'T'
        AND nbrjobs_ecls_code NOT IN ( '90', '92' )
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
)
SELECT DISTINCT
    CASE
        WHEN spbpers_pref_first_name IS NOT NULL THEN
            spbpers_pref_first_name
        ELSE
            spriden_first_name
    END                                                                    AS debtors_first_name,
    spriden_last_name                                                      AS debtors_last_name,
    w_sfrstcr_max_term_code                                                AS last_attend_term,
    nvl2(w_spraddr_pr.spraddr_pidm,
         upper(replace(w_spraddr_pr.spraddr_street_line1, '.', '')),
         nvl2(w_spraddr_ma.spraddr_pidm,
              upper(replace(w_spraddr_ma.spraddr_street_line1, '.', '')),
              upper(replace(w_spraddr_bd.spraddr_street_line1, '.', '')))) AS street_line1,
    nvl2(w_spraddr_pr.spraddr_pidm,
         upper(replace(w_spraddr_pr.spraddr_street_line2, '.', '')),
         nvl2(w_spraddr_ma.spraddr_pidm,
              upper(replace(w_spraddr_ma.spraddr_street_line2, '.', '')),
              upper(replace(w_spraddr_bd.spraddr_street_line2, '.', '')))) AS street_line2,
    nvl2(w_spraddr_pr.spraddr_pidm,
         upper(replace(w_spraddr_pr.spraddr_city, '.', '')),
         nvl2(w_spraddr_ma.spraddr_pidm,
              upper(replace(w_spraddr_ma.spraddr_city, '.', '')),
              upper(replace(w_spraddr_bd.spraddr_city, '.', ''))))         AS city,
    nvl2(w_spraddr_pr.spraddr_pidm,
         upper(replace(w_spraddr_pr.spraddr_stat_code, '.', '')),
         nvl2(w_spraddr_ma.spraddr_pidm,
              upper(replace(w_spraddr_ma.spraddr_stat_code, '.', '')),
              upper(replace(w_spraddr_bd.spraddr_stat_code, '.', ''))))    AS state,
    nvl2(w_spraddr_pr.spraddr_pidm,
         substr(w_spraddr_pr.spraddr_zip, 0, 5),
         nvl2(w_spraddr_ma.spraddr_pidm,
              substr(w_spraddr_ma.spraddr_zip, 0, 5),
              substr(w_spraddr_bd.spraddr_zip, 0, 5)))                     AS zip,
        CASE
        WHEN NOT EXISTS (
            SELECT
                spraddr_atyp_code
            FROM
                spraddr
            WHERE
                spraddr_atyp_code IN ( 'PR' )
                AND ( spraddr_to_date > sysdate
                      OR spraddr_to_date IS NULL )
                AND spraddr_status_ind IS NULL
                AND spraddr_pidm = spriden_pidm
        )
                 AND NOT EXISTS (
            SELECT
                spraddr_atyp_code
            FROM
                spraddr
            WHERE
                spraddr_atyp_code IN ( 'PR' )
                AND ( spraddr_to_date < sysdate
                      OR spraddr_status_ind = 'I' )
                AND spraddr_pidm = spriden_pidm
        ) THEN
            'Y'
        ELSE
            'N'
    END pr_inactive_only,
    CASE
        WHEN NOT EXISTS (
            SELECT
                spraddr_atyp_code
            FROM
                spraddr
            WHERE
                spraddr_atyp_code IN ( 'MA' )
                AND ( spraddr_to_date > sysdate
                      OR spraddr_to_date IS NULL )
                AND spraddr_status_ind IS NULL
                AND spraddr_pidm = spriden_pidm
        )
                 AND NOT EXISTS (
            SELECT
                spraddr_atyp_code
            FROM
                spraddr
            WHERE
                spraddr_atyp_code IN ( 'MA' )
                AND ( spraddr_to_date < sysdate
                      OR spraddr_status_ind = 'I' )
                AND spraddr_pidm = spriden_pidm
        ) THEN
            'Y'
        ELSE
            'N'
    END ma_inactive_only,
    CASE
        WHEN EXISTS (
            SELECT
                spraddr_atyp_code
            FROM
                spraddr
            WHERE
                spraddr_atyp_code IN ( 'BD' )
                AND spraddr_pidm = spriden_pidm
        ) THEN
            'Y'
        ELSE
            'N'
    END bd_exists,
    ''                                                                     AS date_of_debt,
    spbpers_ssn                                                            AS ssn,
    w_tbraccd.tbraccd_balance                                              AS ammount_due,
    spriden_id                                                             AS student_id,
    CASE
        WHEN gorvisa_pidm IS NOT NULL THEN
            'Y'
        ELSE
            'N'
    END                                                                    AS international,
    CASE
        WHEN pebempl_pidm IS NOT NULL THEN
            'Y'
        ELSE
            'N'
    END                                                                    AS is_employee,
    CASE
        WHEN
            saradap_admt_code = '9A'
        THEN
            'Y'
        ELSE
            'N'
    END                                                                    AS is_concurrent,
    CASE
        WHEN 
            w_tbraccd.tbraccd_balance < 50
        THEN 
            'Y'
        ELSE
            'N'
    END                                                                    AS is_sub50
FROM
    w_spriden
    LEFT JOIN w_spbpers ON spbpers_pidm = spriden_pidm
    LEFT JOIN w_tbraccd ON w_tbraccd.tbraccd_pidm = spriden_pidm
    LEFT JOIN w_spraddr_pr ON w_spraddr_pr.spraddr_pidm = spriden_pidm
    LEFT JOIN w_spraddr_ma ON w_spraddr_ma.spraddr_pidm = spriden_pidm
    LEFT JOIN w_spraddr_bd ON w_spraddr_bd.spraddr_pidm = spriden_pidm
    LEFT JOIN w_pebempl ON pebempl_pidm = spriden_pidm
    LEFT JOIN w_gorvisa ON gorvisa_pidm = spriden_pidm
    LEFT JOIN w_sgbstdn ON sgbstdn_pidm = spriden_pidm
    LEFT JOIN w_sfrstcr_max ON w_sfrstcr_max_pidm = spriden_pidm
    LEFT JOIN w_tbraccd_charge ON w_tbraccd_charge_pidm = spriden_pidm
    --JOIN saradap ON saradap_pidm = spriden_pidm
    --JOIN w_saradap ON w_saradap_term_code_entry = saradap_term_code_entry
    JOIN w_saradap ON w_saradap_pidm = spriden_pidm
    JOIN saradap ON saradap_pidm = w_saradap_pidm
                    AND saradap_term_code_entry = w_saradap_term_code_entry
WHERE
    w_sfrstcr_max_term_code < 202420
ORDER BY 
   w_tbraccd.tbraccd_balance DESC 
;
