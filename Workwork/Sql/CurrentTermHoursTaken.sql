WITH g_sfrstcr AS (
    SELECT DISTINCT 
        sfrstcr_pidm    AS g_sfrstcr_pidm,
        sfrstcr_crn     AS g_sfrstcr_crn,
        SUM(sfrstcr_credit_hr) 
        OVER(PARTITION BY sfrstcr_pidm, sfrstcr_crn) AS g_sfrstcr_credit_hr
    FROM 
        sfrstcr
    WHERE 
        sfrstcr_term_code = 202420
    --  sfrstcr_term_code = :lbSYEar.SEMYEAR
)
