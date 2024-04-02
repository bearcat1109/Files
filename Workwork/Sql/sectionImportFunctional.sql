-- Re-added Instructors 1-24-2023 Gabriel + Rob
WITH w_scbcrse AS (
    SELECT DISTINCT
        scbcrse_subj_code                                       AS w_scbcrse_subj_code,
        scbcrse_crse_numb                                       AS w_scbcrse_crse_numb,
        MAX(scbcrse_eff_term)
        OVER(PARTITION BY scbcrse_subj_code, scbcrse_crse_numb) AS w_scbcrse_eff_term
    FROM
        scbcrse
)
SELECT DISTINCT
    ssbsect_crn
    || '.'
    || ssbsect_term_code                      AS "Section_ID",
    scbcrse_title
    || '-' ||
    ssbsect_crn
    || '.'
    || ssbsect_term_code
    ||
    CASE
            WHEN ssbsect_camp_code = '01' THEN
                '.TA.'
            WHEN ssbsect_camp_code = '02' THEN
                '.MK.'
            WHEN ssbsect_camp_code = '03' THEN
                '.BA.'
            WHEN ssbsect_camp_code = '04' THEN
                '.PO.'
            WHEN ssbsect_camp_code = '05' THEN
                '.MI.'
            WHEN ssbsect_camp_code = '06' THEN
                '.PC.'
            WHEN ssbsect_camp_code = '07' THEN
                '.WI.'
            WHEN ssbsect_camp_code = '08' THEN
                '.CO.'
            WHEN ssbsect_camp_code = '09' THEN
                '.TU.'
            ELSE
                ssbsect_camp_code || '.'
    END
    ||
    CASE
        WHEN TO_NUMBER(:main_lb_terms) <= 202510
        THEN(
            CASE
            WHEN ssbsect_schd_code IN ( '04', '06', '08', '10', '11',
                                        '28' ) THEN
                'INDV'
            -- moved 22A/23A to HFLX 3/29/24 berresg
            WHEN ssbsect_schd_code IN ( '22', '23', '31', '22A', '23A',
                                        '30', '27A', '26A', '27', '26',
                                        '33', '32', '33A', '32A', '31A',
                                        '30A' ) THEN
                'BLND'
            -- moved 34/35 to VCM
            WHEN ssbsect_schd_code IN ( '25', '24', '25A', '24A', '21',
                                        '20', '21A', '20A', '35', '34',
                                        '14', '15', '05' ) THEN
                'ONLN'
            WHEN ssbsect_schd_code IN ( '16', '17', '29',  '18', '19'  ) THEN
                'INTN'
            WHEN ssbsect_schd_code IN ( '03', '12', '13', '00A', '01A' ) THEN
                'TRAD'
            WHEN ssbsect_schd_code IN ( '02', '07' ) THEN
                'EXTN'
            --WHEN ssbsect_schd_code IN ( '05' ) THEN
                --'CORR - '
            WHEN ssbsect_schd_code IN ( '00', '01' ) THEN
                'REGC'
            WHEN ssbsect_schd_code IN ( '09' ) THEN
                'ZERO'
            WHEN ssbsect_schd_code LIKE 'CE%' THEN
                'CNED'
            ELSE
                'TRAD'
            END
            )
        WHEN TO_NUMBER(:main_lb_terms) >= 202520
            THEN
            (
                CASE
            WHEN ssbsect_schd_code IN ( '04', '06', '08', '10', '11',
                                        '28' ) THEN
                'INDV'
            -- moved 22A/23A to HFLX 3/29/24 berresg
            WHEN ssbsect_schd_code IN ( '22', '23', '31', --'22A', '23A',
                                        '30', '27A', '26A', '27', '26',
                                        '33', '32', '33A', '32A', '31A',
                                        '30A' ) THEN
                'BLND'
            -- moved 34/35 to VCM
            WHEN ssbsect_schd_code IN ( '25', '24', '25A', '24A', '21',
                                        '20', '21A', '20A', --'35', '34',
                                        '14', '15', '05' ) THEN
                'ONLN'
            WHEN ssbsect_schd_code IN ( '16', '17', '29',  '18', '19'  ) THEN
                'INTN'
            WHEN ssbsect_schd_code IN ( '03', '12', '13', '00A', '01A' ) THEN
                'TRAD'
            WHEN ssbsect_schd_code IN ( '02', '07' ) THEN
                'EXTN'
            --WHEN ssbsect_schd_code IN ( '05' ) THEN
                --'CORR - '
            WHEN ssbsect_schd_code IN ( '00', '01' ) THEN
                'REGC'
            WHEN ssbsect_schd_code IN ( '09' ) THEN
                'ZERO'
            WHEN ssbsect_schd_code LIKE 'CE%' THEN
                'CNED'
            WHEN
                ssbsect_schd_code IN ('22A', '23A')
            THEN
                'HFLX'
            WHEN
                ssbsect_schd_code IN ('34', '35')
            THEN
                'VCM'
            ELSE
                'TRAD'
            END
            )
    END AS "Section_Name",
    scbcrse_subj_code
    || ' '
    || scbcrse_crse_numb                      AS "Course_Code",
    nvl(gobtpac_external_user, 'placeholder') || '@nsuok.edu'     AS "Instructor",
    to_char((stvterm_start_date - 28), 'MM/DD/YYYY') AS "Start_Date",
    to_char(stvterm_end_date, 'MM/DD/YYYY')   AS "End_Date",
    stvterm_code                              AS "Term"
FROM
         ssbsect
    JOIN w_scbcrse ON w_scbcrse_subj_code = ssbsect_subj_code
                      AND w_scbcrse_crse_numb = ssbsect_crse_numb
    JOIN scbcrse ON scbcrse_subj_code = w_scbcrse_subj_code
                    AND scbcrse_crse_numb = w_scbcrse_crse_numb
                    AND scbcrse_eff_term = w_scbcrse_eff_term
    JOIN stvterm ON ssbsect_term_code = stvterm_code
    JOIN ssrmeet ON ssrmeet_crn = ssbsect_crn
                    AND ssrmeet_term_code = ssbsect_term_code
    JOIN nsudev.wm_sll_crse ON wm_sll_crse_crse_numb = ssbsect_crse_numb
         AND wm_sll_crse_subj_code = ssbsect_subj_code
    LEFT JOIN gobtpac ON gobtpac_pidm = ssksels.f_section_instructor(ssbsect_crn, ssbsect_term_code, 'Y', '')
WHERE
    ssbsect_ssts_code = 'A'
    AND stvterm_code = :main_lb_terms
