SELECT DISTINCT
scbcrse_subj_code || ' ' || scbcrse_crse_numb CourseID,
stvdept_desc NodeName,
scbcrse_title Course_Title,
     CASE
        WHEN scbcrse_title LIKE '%INTERNSHIP%'
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
ORDER BY CourseID