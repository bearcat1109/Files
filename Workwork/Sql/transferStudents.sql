-- Transfer students for a given term, Gabriel Berres 4-12-2024
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
