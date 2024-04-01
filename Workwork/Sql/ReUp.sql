-- ReUp daily report. Started 3/27/2024 Gabriel Berres
WITH w_sgbstdn  AS (
    SELECT DISTINCT
        sgbstdn_pidm                    w_sgbstdn_pidm,
        MAX(sgbstdn_term_code_eff)
        OVER(PARTITION BY sgbstdn_pidm) w_sgbstdn_term_code_eff
    FROM
        sgbstdn 
    WHERE
        sgbstdn_term_code_eff <= 
        (
            SELECT 
                MAX(stvterm_code)
            FROM 
                stvterm
            WHERE
                stvterm_start_date < sysdate
        )
), w_sgbstdn_date AS (
    SELECT 
        w_sgbstdn_pidm,
        w_sgbstdn_term_code_eff,
        stvterm_end_date    w_stvterm_end_date
    FROM
        w_sgbstdn
        JOIN stvterm ON w_sgbstdn_term_code_eff = stvterm_code
),  w_sorlcur AS (
    SELECT DISTINCT
        sorlcur_pidm                    w_sorlcur_pidm,
        MAX(sorlcur_seqno)
        OVER(PARTITION BY sorlcur_pidm) w_sorlcur_seqno
    FROM
        sorlcur
), w_sfrstcr AS (
    SELECT
        sfrstcr_pidm w_sfrstcr_pidm,
        sfrstcr_term_code w_sfrstcr_term_code,
        SUM(sfrstcr_credit_hr) AS w_sfrstcr_credit_hr
    FROM 
        sfrstcr
    WHERE
        sfrstcr_rsts_code IN ('RE', 'RW')
    GROUP BY
        sfrstcr_pidm,
        sfrstcr_term_code
),  w_shrttrm AS (
    SELECT DISTINCT
        shrttrm_pidm                    w_shrttrm_pidm,
        MAX(shrttrm_term_code)
        OVER(PARTITION BY shrttrm_pidm) w_shrttrm_term_code
    FROM
        shrttrm
    WHERE
        shrttrm_term_code < (
            SELECT 
                MAX(stvterm_code)
            FROM 
                stvterm
            WHERE
                stvterm_start_date < sysdate
        )
), w_sprhold AS (
    SELECT DISTINCT
        sprhold_pidm    w_sprhold_pidm,
        LISTAGG(sprhold_hldd_code, '|') WITHIN GROUP (ORDER BY sprhold_hldd_code) AS w_sprhold_concat_holds
    FROM 
        sprhold
    WHERE
        sprhold_to_date > sysdate
    GROUP BY 
        sprhold_pidm
), w_tbraccd AS (
    SELECT
        tbraccd_pidm         w_tbraccd_pidm,
        SUM(tbraccd_balance) w_tbraccd_balance
    FROM
        tbraccd
    GROUP BY
        tbraccd_pidm
), w_rorsapr AS (
    SELECT
        rorsapr_pidm AS w_rorsapr_pidm,
        rorsapr_sapr_code AS w_rorsapr_sapr_code,
        RORSAPR_TERM_CODE AS w_rorsapr_term_code,
        rorsapr_activity_date AS w_rorsapr_activity_date
    FROM
        RORSAPR
    WHERE
        rorsapr_term_code <= (
            SELECT 
                MAX(stvterm_code)
            FROM stvterm
            WHERE stvterm_start_date < sysdate
        )
), w_tbraccd_term AS (
    SELECT 
        tbraccd_pidm            w_tbraccd_term_pidm,
        tbraccd_term_code       w_tbraccd_term_term_code,
        SUM(tbraccd_amount)     w_tbraccd_term_sum
    FROM
        tbraccd
    WHERE
        tbraccd_detail_code IN
    (SELECT
        tbbdetc_detail_code
    FROM
        tbbdetc
    WHERE
    ( upper(tbbdetc_desc) LIKE '%TUIT%'
      AND tbbdetc_detail_code LIKE 'T%' )
    OR ( tbbdetc_detail_code LIKE 'F%'
         AND upper(tbbdetc_desc) LIKE '%FEE%' ))
    GROUP by tbraccd_pidm, tbraccd_term_code
)

SELECT DISTINCT
    --spriden_last_name || ', ' || spriden_first_name name,
    spriden_id id,
    --spriden_pidm pidm,
    stvcoll_desc college,
    stvmajr_desc || ' - ' || substr(stvmajr_cipc_code, 1, 2) field_study,
    w_sfrstcr_term_code || ', ' || w_sfrstcr_credit_hr term_and_hours_taken,
    CASE
        WHEN
            w_sfrstcr_credit_hr >= 12
        THEN
            'Full Time'
        WHEN 
            w_sfrstcr_credit_hr < 12 AND w_sfrstcr_credit_hr > 0
        THEN
            'Part Time'
        ELSE
            'Other'
        END AS ft_pt_status,
    w_stvterm_end_date  last_attend_date,
    to_char(round(nvl(o_shrlgpa.shrlgpa_gpa, 0.00),
                  2),
            'fm90D00')                        cumulative_gpa,
    t_shrlgpa.shrlgpa_hours_earned            tfer_earned_hrs,
    i_shrlgpa.shrlgpa_hours_attempted         i_attempted_hours,
    i_shrlgpa.shrlgpa_hours_earned            i_earned_hours,
    stvastd_desc                              standing,
    rorsapr_sapr_code                         most_recent_sap,
    w_sprhold_concat_holds                    concat_holds,
    w_tbraccd_balance                         balance,
    stvests_desc                              enrollment_status,
    shrtgpa_hours_earned                      term_enrolled_hrs,
    w_tbraccd_term_sum                        term_sum,
    w_sfrstcr_term_code                       term,
    (
        SELECT 
            stvterm_start_date
        FROM
            stvterm
        WHERE
            stvterm_code = w_sfrstcr_term_code
    )                                         term_start_date,
    shrdgmr_grst_code                         grad_app_status,
    (
        SELECT
            stvterm_end_date
        FROM 
            stvterm
        WHERE 
            stvterm_code = shrdgmr_term_code_grad
    )                                           grad_date,
    sysdate                                     reup_first_run_date
FROM 
    goradid
    JOIN spriden ON spriden_pidm = goradid_pidm
        AND spriden_change_ind is null
        AND spriden_entity_ind = 'P'
    -- Student/Major
    JOIN w_sgbstdn ON w_sgbstdn_pidm = goradid_pidm
    JOIN sgbstdn ON sgbstdn_pidm = w_sgbstdn_pidm
        AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
        AND sgbstdn_stst_code NOT IN ( 'IS', 'IG' )
    JOIN w_sgbstdn_date ON w_sgbstdn_date.w_sgbstdn_pidm = goradid_pidm
    JOIN stvmajr on stvmajr_code = sgbstdn_majr_code_1
    LEFT JOIN w_sfrstcr ON w_sfrstcr_pidm = goradid_pidm
    -- GPA
    LEFT JOIN shrlgpa o_shrlgpa ON o_shrlgpa.shrlgpa_pidm = goradid_pidm
        AND o_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
        AND o_shrlgpa.shrlgpa_gpa_type_ind = 'O'
    -- Xfer hours
    LEFT JOIN shrlgpa t_shrlgpa ON t_shrlgpa.shrlgpa_pidm = goradid_pidm
        AND t_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
        AND t_shrlgpa.shrlgpa_gpa_type_ind = 'T'
    -- Inst hours
    LEFT JOIN shrlgpa i_shrlgpa ON i_shrlgpa.shrlgpa_pidm = goradid_pidm
        AND i_shrlgpa.shrlgpa_levl_code = sgbstdn_levl_code
        AND i_shrlgpa.shrlgpa_gpa_type_ind = 'I'
    -- Term Hours
    LEFT JOIN shrtgpa ON shrtgpa_pidm = goradid_pidm
        AND shrtgpa_term_code = w_sfrstcr_term_code
    -- College
    JOIN w_sorlcur ON w_sorlcur_pidm = goradid_pidm
    JOIN sorlcur ON sorlcur_pidm = w_sorlcur_pidm
        AND sorlcur_seqno = w_sorlcur_seqno
    LEFT JOIN stvcoll ON sorlcur_coll_code = stvcoll_code
    -- Standing
    LEFT JOIN w_shrttrm ON w_shrttrm_pidm = goradid_pidm
    LEFT JOIN shrttrm ON shrttrm_pidm = w_shrttrm_pidm
        AND shrttrm_term_code = w_shrttrm_term_code
    LEFT JOIN stvastd ON stvastd_code = shrttrm_astd_code_end_of_term
    -- SAP
    LEFT JOIN rorsapr ON rorsapr_pidm = goradid_pidm
        AND rorsapr_term_code = w_sfrstcr_term_code
    LEFT JOIN w_rorsapr ON w_rorsapr_pidm = goradid_pidm
    -- Holds
    LEFT JOIN w_sprhold ON w_sprhold_pidm = goradid_pidm
    --LEFT JOIN sprhold ON sprhold_pidm = goradid_pidm
    -- Balance
    LEFT JOIN w_tbraccd ON w_tbraccd_pidm = goradid_pidm
    LEFT JOIN w_tbraccd_term ON w_tbraccd_term_pidm = goradid_pidm
        AND w_sfrstcr_term_code = w_tbraccd_term_term_code
    -- Enrollment
    LEFT JOIN sfbetrm ON sfbetrm_pidm = goradid_pidm
    LEFT JOIN stvests ON stvests_code = sfbetrm_ests_code
    -- Graduation
    --LEFT JOIN shbgapp ON shbgapp_pidm = goradid_pidm
    LEFT JOIN shrdgmr ON shrdgmr_pidm = goradid_pidm
WHERE
    goradid_adid_code = 'REUP'
ORDER BY
    spriden_id ASC;
