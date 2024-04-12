SELECT * FROM sorpcol;
INFO sorpcol;
SELECT distinct sorpcol_official_trans FROMsorpcol;

SELECT DISTINCT 
    spriden_last_name || ', ' || spriden_first_name name,
    sorpcol_official_trans official_trans
FROM
    sfbetrm
    JOIN spriden ON spriden_pidm = sfbetrm_pidm
        AND spriden_change_ind IS NULL
    JOIN sorpcol ON sorpcol_pidm = sfbetrm_pidm
        AND sorpcol_official_trans = 'Y'
        AND sorpcol_trans_recv_date IS NOT NULL
        AND sorpcol_trans_rev_date IS NOT NULL
WHERE
    sfbetrm_term_code = '202430';
    

-- Sprhold
SELECT * FROM sprhold;
INFO sprhold;
INFO stvhold;
SELECT distinct sprhold_hldd_code FROMsprhold;
SELECT * FROM stvhldd;

SELECT DISTINCT 
    spriden_last_name || ', ' || spriden_first_name name,
    sprhold_hldd_code hold,
    stvhldd_desc hold_desc
FROM
    sprhold
    JOIN spriden on spriden_pidm = sprhold_pidm
        AND spriden_change_ind IS NULL
    JOIN stvhldd on stvhldd_code = sprhold_hldd_code
WHERE
    sprhold_hldd_code = '11'
    AND sprhold_to_date > sysdate;
    
-- SGRADVR
SELECT * FROM sgradvr;
INFO sgradvr;
SELECT DISTINCT sgradvr_advr_code FROM sgradvr;
SELECT * FROM stvadvr;

SELECT DISTINCT
    s_spriden.spriden_last_name || ', ' || s_spriden.spriden_first_name stu_name,
    sgradvr_advr_code code,
    stvadvr_desc,
    a_spriden.spriden_last_name || ', ' || a_spriden.spriden_first_name adv_name
FROM
    sfbetrm
    JOIN sgradvr ON sgradvr_pidm = sfbetrm_pidm
    JOIN spriden s_spriden ON s_spriden.spriden_pidm = sgradvr_pidm
        AND s_spriden.spriden_change_ind IS NULL
    JOIN spriden a_spriden ON a_spriden.spriden_pidm = sgradvr_advr_pidm
        AND a_spriden.spriden_change_ind IS NULL
    JOIN stvadvr ON stvadvr_code = sgradvr_advr_code
WHERE
    sfbetrm_term_code = '202430'
ORDER BY stu_name ASC;

-- STVTESC
INFO stvtesc;
SELECT * FROM stvtesc;
SELECT * FROM sortest;

SELECT 
    spriden_last_name || ', ' || spriden_first_name name,
    sortest_tesc_code test_code,
    stvtesc_desc test_desc,
    sortest_test_score score
FROM
    sfbetrm
    JOIN spriden ON spriden_pidm = sfbetrm_pidm
        AND spriden_change_ind IS NULL
    JOIN sortest ON sortest_pidm = sfbetrm_pidm
        AND sortest_test_date = 
        (
            SELECT
                MAX(sortest_test_date) OVER(PARTITION BY sortest_tesc_code)
            FROM
                sortest
            FETCH FIRST 1 ROW ONLY
        )
    JOIN stvtesc ON stvtesc_code = sortest_tesc_code
WHERE
    sfbetrm_term_code = '202430'
    AND sortest_tesc_code LIKE 'A0_'
ORDER BY name ASC;
    
    
