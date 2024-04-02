-- Psych Majors, 4-2-2024, Gabriel Berres
WITH w_sgbstdn AS 
(
    SELECT DISTINCT
        sgbstdn_pidm                    w_sgbstdn_pidm,
        MAX(sgbstdn_term_code_eff)
        OVER(PARTITION BY sgbstdn_pidm) w_sgbstdn_term_code_eff
    FROM
        sgbstdn
    WHERE 
        sgbstdn_term_code_eff <= to_number('202430')
)
SELECT 
    w_sgbstdn_pidm,
    spriden_last_name || ', ' || spriden_first_name name_,
    ma_stvmajr.stvmajr_desc major,
    co_stvmajr.stvmajr_desc concentration,
    mi_stvmajr.stvmajr_desc minor
FROM
    sfbetrm
    JOIN w_sgbstdn ON w_sgbstdn_pidm = sfbetrm_pidm
    JOIN sgbstdn ON sgbstdn_pidm = w_sgbstdn_pidm
        AND sgbstdn_term_code_eff = w_sgbstdn_term_code_eff
        AND sgbstdn_stst_code NOT IN ( 'IS', 'IG' )
    JOIN stvmajr ma_stvmajr ON ma_stvmajr.stvmajr_code = sgbstdn_majr_code_1
    LEFT JOIN stvmajr co_stvmajr ON co_stvmajr.stvmajr_code = sgbstdn_majr_code_conc_1
    LEFT JOIN stvmajr mi_stvmajr ON mi_stvmajr.stvmajr_code = sgbstdn_majr_code_minr_1
    JOIN spriden ON spriden_pidm = sfbetrm_pidm
        AND spriden_change_ind IS NULL
        AND spriden_entity_ind = 'P'
WHERE
    sfbetrm_term_code = 202430
    AND sgbstdn_majr_code_1 IN ( 'P076', '6756', '3565' )
    
