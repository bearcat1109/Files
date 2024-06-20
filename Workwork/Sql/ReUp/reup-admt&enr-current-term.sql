-- Revised ReUp, no earned hours to allow future semesters.

WITH w_sgbstdn  AS (
    SELECT DISTINCT
        sgbstdn_pidm                    w_sgbstdn_pidm,
--        MAX(sgbstdn_term_code_eff)
--        OVER(PARTITION BY sgbstdn_pidm) w_sgbstdn_term_code_eff
        sgbstdn_term_code_eff            w_sgbstdn_term_code_eff
    FROM
        sgbstdn 
    WHERE
        sgbstdn_term_code_eff = (
            SELECT 
                MAX(stvterm_code)
            FROM 
                stvterm
            WHERE
                stvterm_start_date <= sysdate
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
        AND sfrstcr_term_code = (
            SELECT 
                MAX(stvterm_code)
            FROM 
                stvterm
            WHERE
                stvterm_start_date <= sysdate
        )
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
        shrttrm_term_code = (
            SELECT 
                MAX(stvterm_code)
            FROM 
                stvterm
            WHERE
                stvterm_start_date <= sysdate
        )
), w_sprhold AS (
    SELECT DISTINCT
        sprhold_pidm    w_sprhold_pidm,
        LISTAGG(sprhold_hldd_code, '|') WITHIN GROUP (ORDER BY sprhold_hldd_code) AS w_sprhold_concat_holds
    FROM 
        sprhold
    WHERE
        sprhold_to_date >= sysdate
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
        rorsapr_term_code = (
            SELECT 
                MAX(stvterm_code)
            FROM 
                stvterm
            WHERE 
                stvterm_start_date <= sysdate
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
), w_shrdgmr AS 
(
    SELECT
        shrdgmr_pidm    w_shrdgmr_pidm,
        --shrdgmr_grst_code   w_shrdgmr_grst_code,
        shrdgmr_degs_code   w_shrdgmr_degs_code,
        shrdgmr_term_code_grad   w_shrdgmr_term_code_grad,
        MAX(shrdgmr_grad_date)  OVER(PARTITION BY shrdgmr_pidm)  w_shrdgmr_grad_date
    FROM 
        shrdgmr
    WHERE
        shrdgmr_seq_no = 
            (
                SELECT 
                    MAX(shrdgmr_seq_no) OVER(PARTITION BY shrdgmr_pidm) 
                FROM 
                    shrdgmr
                FETCH FIRST 1 ROWS ONLY
            )
), w_saradap_appl AS
(
    SELECT saradap_pidm     w_saradap_appl_pidm,
       CASE 
           WHEN COUNT(CASE WHEN saradap_apst_code = 'D' THEN 1 END) OVER (PARTITION BY saradap_pidm) > 0
           THEN LISTAGG(CASE WHEN saradap_apst_code = 'D' THEN TO_CHAR(saradap_appl_date, 'mm/dd/yyyy') ELSE NULL END, ', ') WITHIN GROUP (ORDER BY saradap_appl_date) OVER (PARTITION BY saradap_pidm)
           ELSE TO_CHAR(MIN(saradap_appl_date) OVER (PARTITION BY saradap_pidm), 'mm/dd/yyyy')
       END AS w_saradap_appl_dates
FROM saradap
), w_saradap_apst AS
(
    SELECT 
    saradap_pidm        w_saradap_apst_pidm,
    CASE 
        WHEN COUNT(CASE WHEN saradap_apst_code = 'D' THEN 1 END) OVER (PARTITION BY saradap_pidm) > 0
        THEN LISTAGG(CASE WHEN saradap_apst_code = 'D' THEN TO_CHAR(saradap_apst_date, 'mm/dd/yyyy') END, ', ') 
             WITHIN GROUP (ORDER BY saradap_apst_date) OVER (PARTITION BY saradap_pidm)
        ELSE TO_CHAR(MIN(saradap_apst_date) OVER (PARTITION BY saradap_pidm), 'mm/dd/yyyy')
    END AS w_saradap_apst_dates,
    CASE 
        WHEN COUNT(CASE WHEN saradap_apst_code = 'D' THEN 1 END) OVER (PARTITION BY saradap_pidm) > 0
        THEN LISTAGG(CASE WHEN saradap_apst_code = 'D' THEN stvapst_desc END, ', ') 
             WITHIN GROUP (ORDER BY saradap_apst_date) OVER (PARTITION BY saradap_pidm)
        ELSE MIN(stvapst_desc) OVER (PARTITION BY saradap_pidm)
    END AS w_saradap_apst_descs
FROM 
    saradap
JOIN 
    stvapst ON saradap.saradap_apst_code = stvapst.stvapst_code
GROUP BY 
    saradap_pidm, saradap_apst_date, saradap_apst_code, stvapst_desc
),

w_sarappd AS 
(
    SELECT DISTINCT
        sarappd_pidm                                  w_sarappd_pidm,
        MAX(sarappd_apdc_date) OVER(PARTITION BY sarappd_pidm)  w_sarappd_apdc_date,
        --sarappd_apdc_date   w_sarappd_apdc_date,
        sarappd_apdc_code                             w_sarappd_apdc_code,
        MAX(sarappd_appl_no) OVER(PARTITION BY sarappd_pidm)    w_sarappd_appl_no
    FROM 
        sarappd
)

SELECT DISTINCT
    spriden_id student_id,
    stvcoll_desc college,
    stvmajr_desc || ' - ' || substr(stvmajr_cipc_code, 1, 2) program_of_study,
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
    END AS full_time_or_part_time_status,
    stvastd_desc                              academic_standing,
    rorsapr_sapr_code                         satisfactory_academic_progress_status,
    w_sprhold_concat_holds                    current_holds,
    w_tbraccd_balance                         balance_due,
    stvests_desc                              enrollment_status,
    w_sfrstcr_credit_hr                       enrolled_units,
    w_sfrstcr_term_code                       term,
    (
        SELECT 
            stvterm_start_date
        FROM
            stvterm
        WHERE
            stvterm_code = w_sfrstcr_term_code
    )                                         term_start_date,
    w_shrdgmr_degs_code                         graduation_status,
    w_shrdgmr_grad_date                         official_graduation_date,
    '08-JAN-24'                                     reup_first_run_date,
    w_saradap_appl_dates                                  application_date,
    w_saradap_apst_descs                                  application_status_desc,
    w_saradap_apst_dates                                  application_status_date,
    to_char(w_sarappd_apdc_date, 'mm/dd/yyyy')  latest_decision_date,
    MIN(stvapdc_desc) OVER(PARTITION BY w_sarappd_pidm)     latest_decision_desc
FROM
    sfbetrm
    JOIN goradid ON goradid_pidm = sfbetrm_pidm
        AND goradid_adid_code = 'REUP'
    JOIN spriden ON spriden_pidm = sfbetrm_pidm
        AND spriden_change_ind is null
        AND spriden_entity_ind = 'P'
        AND spriden_id = goradid_additional_id
    -- Student/Major
    JOIN w_sgbstdn ON w_sgbstdn_pidm = sfbetrm_pidm
    JOIN sgbstdn ON sgbstdn_pidm = w_sgbstdn_pidm
        AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
        AND sgbstdn_stst_code NOT IN ( 'IS', 'IG' )
    JOIN w_sgbstdn_date ON w_sgbstdn_date.w_sgbstdn_pidm = sfbetrm_pidm
    JOIN stvmajr on stvmajr_code = sgbstdn_majr_code_1
    JOIN w_sfrstcr ON w_sfrstcr_pidm = sfbetrm_pidm
    -- College
    LEFT JOIN w_sorlcur ON w_sorlcur_pidm = sfbetrm_pidm
    LEFT JOIN sorlcur ON sorlcur_pidm = w_sorlcur_pidm
        AND sorlcur_seqno = w_sorlcur_seqno
    LEFT JOIN stvcoll ON sorlcur_coll_code = stvcoll_code
    -- Standing
    LEFT JOIN w_shrttrm ON w_shrttrm_pidm = sfbetrm_pidm
    LEFT JOIN shrttrm ON shrttrm_pidm = w_shrttrm_pidm
        AND shrttrm_term_code = w_shrttrm_term_code
    LEFT JOIN stvastd ON stvastd_code = shrttrm_astd_code_end_of_term
    -- SAP
    LEFT JOIN rorsapr ON rorsapr_pidm = sfbetrm_pidm
        AND rorsapr_term_code = w_sfrstcr_term_code
    LEFT JOIN w_rorsapr ON w_rorsapr_pidm = sfbetrm_pidm
    -- Holds
    LEFT JOIN w_sprhold ON w_sprhold_pidm = sfbetrm_pidm
    --LEFT JOIN sprhold ON sprhold_pidm = sfbetrm_pidm
    -- Balance
    LEFT JOIN w_tbraccd ON w_tbraccd_pidm = sfbetrm_pidm
    LEFT JOIN w_tbraccd_term ON w_tbraccd_term_pidm = sfbetrm_pidm
        AND w_sfrstcr_term_code = w_tbraccd_term_term_code
    -- Enrollment
--    LEFT JOIN sfbetrm ON sfbetrm_pidm = sfbetrm_pidm
--        AND sfbetrm_term_code = w_sfrstcr_term_code
    LEFT JOIN stvests ON stvests_code = sfbetrm_ests_code
    -- Graduation
    LEFT JOIN w_shrdgmr ON w_shrdgmr_pidm = sfbetrm_pidm
    
    -- Application Dates/Decision Dates (4/24/2024)
    JOIN w_saradap_appl ON w_saradap_appl_pidm = sfbetrm_pidm
    JOIN w_saradap_apst ON w_saradap_apst_pidm = sfbetrm_pidm
    --JOIN stvapst ON stvapst_code = saradap_apst_code
    JOIN w_sarappd ON w_sarappd_pidm = sfbetrm_pidm
    --LEFT JOIN sarappd ON sarappd_pidm = sfbetrm_pidm
    LEFT JOIN stvapdc ON stvapdc_code = w_sarappd_apdc_code
--WHERE
    --sfbetrm_term_code IN ('202510', '202520');
    --sfbetrm_term_code = '202510';
WHERE
    sfbetrm_ests_code = 'EL'
ORDER BY
    spriden_id ASC,
    w_sfrstcr_term_code DESC;  