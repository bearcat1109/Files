WITH u_saradap AS
(
    SELECT DISTINCT
        saradap_pidm           u_saradap_pidm,
        saradap_apst_date      u_saradap_apst_date,
        saradap_admt_code      u_saradap_admt_code,
        saradap_styp_code      u_saradap_styp_code
    FROM
        saradap
    WHERE
        saradap_admt_code IN ('1A', '9A') --1A undergrad, 9A concurrent
        AND saradap_styp_code IN ('F', 'L')  -- F Freshman, L concurrent
)
SELECT DISTINCT
    spriden_id,
    spriden_first_name,
    spriden_last_name,
    to_char(spbpers_birth_date, 'YYYY') birth_year,
    sgbstdn_pidm,
    to_char(spbpers_birth_date, 'mmddyy') birth_date
    
FROM
         sgbstdn
    JOIN stvterm ON sgbstdn_term_code_eff = stvterm_code
    LEFT JOIN stvstyp ON sgbstdn_styp_code = stvstyp_code
    LEFT JOIN stvstst ON sgbstdn_stst_code = stvstst_code
    LEFT JOIN gobtpac ON gobtpac_pidm = sgbstdn_pidm
    LEFT JOIN spriden ON spriden_pidm = sgbstdn_pidm
    LEFT JOIN spbpers ON spbpers_pidm = sgbstdn_pidm
    LEFT JOIN u_saradap ON u_saradap_pidm = sgbstdn_pidm
WHERE
        sgbstdn_activity_date >= ( sysdate - 730 )
    AND sgbstdn_term_code_eff IN (
        SELECT *
        FROM (
            SELECT stvterm_code
            FROM stvterm
            WHERE stvterm_code >= (
                SELECT MAX(s2.stvterm_code)
                FROM stvterm s2
                WHERE sysdate > s2.stvterm_end_date
                AND stvterm_code LIKE '%0'
            )
            AND stvterm_code LIKE '%0'
            ORDER BY stvterm_code ASC
        )
        WHERE ROWNUM <= 5
    )
    AND gobtpac_external_user IS NULL
    AND spriden_change_ind IS NULL
    AND (u_saradap_apst_date < (sysdate - 5) OR u_saradap_apst_date IS NULL)
