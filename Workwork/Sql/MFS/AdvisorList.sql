-- MFS Advisor List
-- Id, Last, First, Enrollment_status, Classification, College, Major, First concentration, Advisor
-- Report started 12/5/2023

WITH w_sgbstdn AS
(
    SELECT DISTINCT
        sgbstdn_pidm                    w_sgbstdn_pidm,
        MAX(sgbstdn_term_code_eff)
        OVER(PARTITION BY sgbstdn_pidm) w_sgbstdn_term_code_eff
    FROM
        sgbstdn
    WHERE
        sgbstdn_term_code_eff <= 202420
), w_sorlcur AS (
    SELECT DISTINCT
        sorlcur_pidm                    w_sorlcur_pidm,
        MAX(sorlcur_seqno)
        OVER(PARTITION BY sorlcur_pidm) w_sorlcur_seqno
    FROM
        sorlcur
), w_sgradvr AS (
    SELECT DISTINCT
        sgradvr_pidm                    w_sgradvr_pidm,
        MAX(sgradvr_term_code_eff)
        OVER(PARTITION BY sgradvr_pidm) w_sgradvr_term_code_eff
    FROM
        sgradvr
    WHERE
        sgradvr_term_code_eff <= 202420
        AND sgradvr_prim_ind = 'Y'
)
SELECT DISTINCT
    s_spriden.spriden_id                                            ID,
    s_spriden.spriden_last_name                                     LAST,
    s_spriden.spriden_first_name                                    FIRST,
    sfbetrm_ests_code                                               ENROLLMENT_STATUS,
    stvclas_desc                                                    CLASSIFICATION,
    stvcoll_desc                                                    COLLEGE_DESC,
    maj_stvmajr.stvmajr_desc                                        MAJOR_DESC,
    con_stvmajr.stvmajr_desc                                        FIRST_CONCENTRATION_DESC,
    a_spriden.spriden_last_name
    || ', '
    || a_spriden.spriden_first_name
    || ' '
    || substr(a_spriden.spriden_mi, 1, 1)
    || '.'                                                          ADVISOR
FROM 
        sfbetrm
        JOIN w_sgbstdn ON w_sgbstdn_pidm = sfbetrm_pidm
        JOIN sgbstdn ON sgbstdn_pidm = w_sgbstdn_pidm
            AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
            AND sgbstdn_stst_code NOT IN ( 'IS', 'IG' )
        LEFT JOIN w_sgradvr ON w_sgradvr_pidm = sfbetrm_pidm
        LEFT JOIN sgradvr ON sgradvr_pidm = w_sgradvr_pidm
            AND sgradvr_prim_ind = 'Y'
            AND sgradvr_term_code_eff = w_sgradvr_term_code_eff
        JOIN spriden s_spriden ON sfbetrm_pidm = s_spriden.spriden_pidm
            AND s_spriden.spriden_change_ind IS NULL
        LEFT JOIN spriden a_spriden ON a_spriden.spriden_pidm = sgradvr_advr_pidm
            AND a_spriden.spriden_change_ind IS NULL
        JOIN stvmajr maj_stvmajr ON maj_stvmajr.stvmajr_code = sgbstdn_majr_code_1
        LEFT JOIN stvmajr con_stvmajr ON con_stvmajr.stvmajr_code = sgbstdn_majr_code_conc_1
        JOIN stvclas ON stvclas_code = sgkclas.f_class_code(sfbetrm_pidm, sgbstdn_levl_code, 202420)
        LEFT JOIN w_sorlcur ON w_sorlcur_pidm = sfbetrm_pidm
        LEFT JOIN sorlcur ON sorlcur_pidm = w_sorlcur_pidm
            AND sorlcur_seqno = w_sorlcur_seqno
        LEFT JOIN stvcoll ON sorlcur_coll_code = stvcoll_code
WHERE
    sfbetrm_term_code = 202420
    AND sfbetrm_ests_code = 'EL'
;      
