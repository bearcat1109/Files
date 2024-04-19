select * from rrrareq;
info rrrareq;

WITH w_rrrareq AS 
(
     SELECT DISTINCT
        rrrareq_pidm        w_rrrareq_pidm,
        LISTAGG(rrrareq_treq_code, '|') WITHIN GROUP (ORDER BY rrrareq_treq_code) AS w_rrrareq_concat_codes
    FROM 
        rrrareq
    WHERE
        rrrareq_aidy_code = '2324'
    GROUP BY 
        rrrareq_pidm
)
    SELECT
        spriden_id      banner_id,
        spriden_last_name || ', ' || spriden_first_name name,
        w_rrrareq_concat_codes     codes
    FROM 
        w_rrrareq 
        LEFT JOIN spriden ON spriden_pidm = w_rrrareq_pidm
            AND spriden_change_ind IS NULL
            AND spriden_entity_ind = 'P'
    ORDER BY 1, 2 ASC;
;
