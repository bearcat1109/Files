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
), w_sorlcur AS (
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
)

SELECT DISTINCT
    --spriden_last_name || ', ' || spriden_first_name name,
    spriden_id id,
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
        END AS ft_pt_status
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
    JOIN stvmajr on stvmajr_code = sgbstdn_majr_code_1
    LEFT JOIN w_sfrstcr ON w_sfrstcr_pidm = goradid_pidm
    -- College
    JOIN w_sorlcur ON w_sorlcur_pidm = goradid_pidm
    JOIN sorlcur ON sorlcur_pidm = w_sorlcur_pidm
        AND sorlcur_seqno = w_sorlcur_seqno
    LEFT JOIN stvcoll ON sorlcur_coll_code = stvcoll_code
WHERE
    goradid_adid_code = 'REUP'
ORDER BY
    spriden_id asc;
