SELECT
    *
FROM
    stvmajr
WHERE
    stvmajr_code IN ( 'P076', '6756', '3565' );

select * from sgbstdn;

SELECT
    sgbstdn_pidm pidm,
    sgbstdn_term_code_eff term_eff,
    sgbstdn_majr_code_1 major_code,
    sgbstdn_majr_code_minr_1 minor_code,
    mj_stvmajr.stvmajr_desc major,
    mn_stvmajr.stvmajr_desc minor
FROM
    sgbstdn
    LEFT JOIN stvmajr mj_stvmajr ON mj_stvmajr.stvmajr_code = sgbstdn_majr_code_1
    LEFT JOIN stvmajr mn_stvmajr ON mn_stvmajr.stvmajr_code = sgbstdn_majr_code_minr_1
WHERE
    sgbstdn_pidm = 247662
ORDER BY 
    sgbstdn_term_code_eff DESC;
    
