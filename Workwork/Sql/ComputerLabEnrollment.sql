SELECT DISTINCT
    ssrmeet_crn
    || '.'
    || ssrmeet_term_code  course_id,
    ssrmeet_term_code     term_code,
    ssrmeet_bldg_code
    || ' '
    || ssrmeet_room_code  AS room,
    scbcrse_title         AS course_title,
    ssbsect_subj_code
    || ' '
    || ssbsect_crse_numb  course_suject,
    scbcrse_credit_hr_low AS credit_hours,
    ssbsect_enrl          enrollment
FROM
         ssrmeet
    JOIN ssbsect ON ssrmeet_crn = ssbsect_crn
                    AND ssrmeet_term_code = ssbsect_term_code
    JOIN scbcrse ON scbcrse_subj_code = ssbsect_subj_code
                    AND scbcrse_crse_numb = ssbsect_crse_numb
                    AND scbcrse_eff_term = (
        SELECT DISTINCT
            MAX(s1.scbcrse_eff_term)
        FROM
            scbcrse s1
        WHERE
                s1.scbcrse_crse_numb = ssbsect_crse_numb
            AND s1.scbcrse_subj_code = ssbsect_subj_code
    )
WHERE
    ssrmeet_bldg_code
    || ' '
    || ssrmeet_room_code IN ( 'WEBB 207', 'WEBB 307', 'BT 126', 'BT 128', 'BT 129',
                              'BT B8', 'SC 270', 'SC LL046', 'BAGLEY 327', 'SS 106',
                              'FITCTR 205', 'WILSON G18', 'WILSON 415', 'BABT 129', 'BAED 113',
                              'BALA 118', 'BALA 130', 'BALB 106', 'BALB 110', 'BALA 230',
                              'BALA 234', 'NSM 209', 'SYNAR 205' )
    AND ssrmeet_term_code = 
    (
        (SELECT DISTINCT MAX(stvterm_code)
            FROM stvterm
            WHERE stvterm_start_date < sysdate
            AND stvterm_desc NOT LIKE 'CE%'
    )
    );
