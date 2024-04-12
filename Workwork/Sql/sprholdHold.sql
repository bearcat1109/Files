-- Current sprhold code of given type. 4-12-2024 Gabriel Berres
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
