-- Pull Majors History, 4-2-2024, Gabriel Berres
SELECT
    sgbstdn_pidm pidm,
    spriden_last_name || ', ' || spriden_first_name concat_name,
    gobtpac_external_user    username,
    sgbstdn_term_code_eff    mjr_term,
    ma1_stvmajr.stvmajr_desc major_1,
    co1_stvmajr.stvmajr_desc concentration_1,
    mi1_stvmajr.stvmajr_desc minor_1,
    ma2_stvmajr.stvmajr_desc major_2,
    co2_stvmajr.stvmajr_desc concentration_2,
    mi2_stvmajr.stvmajr_desc minor_2
FROM
    sgbstdn
    -- Maj/Min/Conc 1
    JOIN stvmajr ma1_stvmajr ON ma1_stvmajr.stvmajr_code = sgbstdn_majr_code_1
    LEFT JOIN stvmajr co1_stvmajr ON co1_stvmajr.stvmajr_code = sgbstdn_majr_code_conc_1
    LEFT JOIN stvmajr mi1_stvmajr ON mi1_stvmajr.stvmajr_code = sgbstdn_majr_code_minr_1
    -- Maj/Min/Conc 2
    LEFT JOIN stvmajr ma2_stvmajr ON ma2_stvmajr.stvmajr_code = sgbstdn_majr_code_1_2
    LEFT JOIN stvmajr co2_stvmajr ON co2_stvmajr.stvmajr_code = sgbstdn_majr_code_conc_1_2
    LEFT JOIN stvmajr mi2_stvmajr ON mi2_stvmajr.stvmajr_code = sgbstdn_majr_code_minr_1_2

    JOIN spriden ON spriden_pidm = sgbstdn_pidm
        AND spriden_change_ind IS NULL
        AND spriden_entity_ind = 'P'
    LEFT JOIN gobtpac ON gobtpac_pidm = sgbstdn_pidm
WHERE
    ( ( spriden_search_last_name LIKE upper(:main_te_search)
                                      || '%' )
      OR ( spriden_id = upper(:main_te_search) )
      OR ( upper(gobtpac_external_user) = upper(:main_te_search) ) )
ORDER BY
      sgbstdn_term_code_eff DESC
