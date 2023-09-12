-- Written 8/31/2023 by Gabriel Berres. Ticket 23659580
SELECT DISTINCT
    goremal_emal_code AS Code,
    goremal_email_address AS Email,
    goremal_status_ind AS Status,
    goremal_preferred_ind AS Preferred
FROM
    goremal join spriden on spriden_pidm = goremal_pidm
WHERE
    spriden_id LIKE :InputBox
    AND spriden_change_ind IS NULL
    AND :btn_go = 1;