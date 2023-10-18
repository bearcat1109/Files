-- Pull FRA Hold info by PIDM/BannerId. Authored 10-17-2023 by Gabriel Berres

SELECT DISTINCT
    sprhold_pidm pidm,
    spriden_id bannerID,
    sprhold_hldd_code holdCode,
    sprhold_from_date fromDate,
    sprhold_to_date toDate,
    sprhold_release_ind release_Ind,
    sprhold_reason reason,
    nsudev.nsu_financial_responsibility.semyear semester,
    nsudev.nsu_financial_responsibility.accepted accepted_date
FROM
    SPRHOLD JOIN nsudev.nsu_financial_responsibility ON sprhold_pidm = nsudev.nsu_financial_responsibility.pidm
            JOIN spriden ON sprhold_pidm = spriden_pidm
WHERE
    SPRHOLD_REASON LIKE '%Fin%'
    AND SPRHOLD_HLDD_CODE = '76'
    AND nsudev.nsu_financial_responsibility.semyear = :DropDown1.stvterm_code
    AND (sprhold_pidm LIKE :edit1) OR (spriden_id LIKE :edit1)
    AND :btnGo IS NOT NULL
ORDER BY
      sprhold_from_date DESC
