-- ReUp Applied, not Admitted - Next Term. - Gabriel Berres 6-13-2024

SELECT
    saradap_pidm    pidm,
    spriden_id      banner_id,
    saradap_appl_date   application_date,
    saradap_apst_code   application_status_code,
    stvapst_desc        application_status_desc
FROM
    saradap
    JOIN goradid ON goradid_pidm = saradap_pidm
        AND goradid_adid_code = 'REUP'
    JOIN spriden ON spriden_pidm = saradap_pidm
        AND spriden_change_ind IS NULL
    JOIN stvapst ON saradap_apst_code = stvapst_code
WHERE
    saradap_apst_code <> 'D'
    AND saradap_term_code_entry = 
        (
            SELECT
                MIN(stvterm_code)
            FROM
                stvterm
            WHERE
                stvterm_start_date >= sysdate
        )
    --AND saradap_apst_code IS NULL
    --AND saradap_term_code_entry = 202510
;

