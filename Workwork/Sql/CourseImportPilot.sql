-- Written by Gabriel Berres 8-25-2023, CourseImport with additional filtering for Pilot.
SELECT DISTINCT
scbcrse_subj_code || ' ' || scbcrse_crse_numb CourseID,
CASE
        WHEN scbcrse_dept_code = 'EFL' AND scbcrse_crse_numb < 5000
        THEN
           'Curriculum and Instruction'
        ELSE
            stvdept_desc
        End as NodeName,
scbcrse_title Course_Title,
     CASE
        WHEN scbcrse_title LIKE '%INTERNSHIP%'
        THEN
            'internship'
        WHEN scbcrse_subj_code = 'EDUC' AND scbcrse_crse_numb IN ('4172', '4252')
        THEN
            'internship'
        ELSE
            'course'
        END as Category,
scbcrse_subj_code || ' ' || scbcrse_crse_numb Code
FROM(
    SELECT DISTINCT
        scbcrse_subj_code                                      AS w_scbcrse_subj_code,
        scbcrse_crse_numb                                      AS w_scbcrse_crse_numb,
        MAX(scbcrse_eff_term)
        OVER(PARTITION BY scbcrse_subj_code, scbcrse_crse_numb) AS w_scbcrse_eff_term
    FROM
        scbcrse) w_scbcrse
        JOIN scbcrse ON scbcrse_subj_code = w_scbcrse_subj_code
                        AND scbcrse_crse_numb = w_scbcrse_crse_numb
                        AND scbcrse_eff_term = w_scbcrse_eff_term
        JOIN stvdept ON stvdept_code = scbcrse_dept_code
        JOIN ssbsect ON scbcrse_crse_numb = ssbsect_crse_numb
                        AND scbcrse_subj_code = ssbsect_subj_code
WHERE scbcrse_coll_code IN ('ED', 'BT') 
    AND scbcrse_csta_code = 'A'
    --AND scbcrse_subj_code IN ('EDUC', 'ELED', 'LIBM', 
    --                          'READ', 'SPED', 'ACCT',
    --                          'BADM', 'BLAW', 'FIN' ,
    --                          'IS'  , 'MGMT', 'MKT'  )
    AND ssbsect_term_code = '202420' 
    AND ssbsect_ssts_code = 'A'
    AND ssbsect_camp_code = '01'
ORDER BY CourseID;