-- 'nfocus Check History' v2, rewritten 11-30-2023 Gabriel Berres
-- Fixed 12-1-2023 Gabriel Berres, Jonathan Petruska, Jason Tidwell

SELECT DISTINCT
    papf.full_name                   fullname,
    paaf.person_id                   personid,
    paa.assignment_id                assignmentid,
    paaf.organization_id             organizationid,
    nvl(paaf.job_id, 0)              jobid,
    petf.element_name                elementname,
    ppa.effective_date               effectivedate,
    nvl(prrv.result_value, '0')      gross_monthly,
    nvl(prrv.result_value, '0') * 12 gross_yearly,
    --resultValueString,
    ppg.segment1                     otrsmember,
    ppb.name                         paybasisname,
    pj.name                          jobcodetitle
FROM
         hr.pay_payroll_actions ppa
    JOIN hr.pay_assignment_actions      paa ON paa.payroll_action_id = ppa.payroll_action_id
    --JOIN w_plb ON w_plb_assignment_action_id = paa.assignment_action_id  
    --JOIN hr.pay_latest_balances plb ON w_plb_assignment_action_id = plb.assignment_action_id
    JOIN hr.per_all_assignments_f       paaf ON paaf.assignment_id = paa.assignment_id
    JOIN hr.per_all_people_f            papf ON papf.person_id = paaf.person_id
    JOIN hr.pay_run_results             prr ON prr.assignment_action_id = paa.assignment_action_id
    JOIN hr.pay_run_result_values       prrv ON prrv.run_result_id = prr.run_result_id
                                          AND REGEXP_LIKE ( result_value,
                                                            '[^A-Za-z]' )
    JOIN hr.pay_element_types_f         petf ON petf.element_type_id = prr.element_type_id
    JOIN hr.pay_input_values_f          pivf ON pivf.input_value_id = prrv.input_value_id
    JOIN hr.pay_people_groups           ppg ON ppg.people_group_id = paaf.people_group_id
    JOIN hr.pay_element_classifications pec ON pec.classification_id = petf.classification_id
    JOIN hr.per_pay_bases               ppb ON ppb.pay_basis_id = paaf.pay_basis_id
    JOIN hr.per_jobs                    pj ON pj.job_id = paaf.job_id
WHERE
        1 = 1
    AND ppa.effective_date BETWEEN :parm_DT_Begin AND :parm_DT_End
    AND ppa.action_type IN ( 'R', 'Q', 'B', 'V' )
    AND ppa.payroll_action_id = paa.payroll_action_id
    AND paa.assignment_id = paaf.assignment_id
    AND ppa.effective_date BETWEEN paaf.effective_start_date AND paaf.effective_end_date
    AND paaf.assignment_type = 'E'
    AND paa.assignment_action_id = prr.assignment_action_id
    AND paaf.person_id = papf.person_id
    AND paaf.job_id = pj.job_id
    AND ppa.effective_date BETWEEN papf.effective_start_date AND papf.effective_end_date
    AND prr.status IN ( 'P', 'PA' )
    AND prr.element_type_id = petf.element_type_id
    AND ppa.effective_date BETWEEN petf.effective_start_date AND petf.effective_end_date
    AND petf.classification_id = pec.classification_id
    AND paaf.people_group_id = ppg.people_group_id
    AND prr.run_result_id = prrv.run_result_id
    AND prrv.input_value_id = pivf.input_value_id
    AND pivf.name = 'Pay Value'
    AND paaf.pay_basis_id = ppb.pay_basis_id
    AND pec.classification_name IN ( 'Earnings', 'Supplemental Earnings' )
 --   and petf.element_name = 'Regular Wages'
 --   and paaf.employment_category = 'FR'
 --   and papf.full_name like 'Butler, Trent A'
    AND papf.national_identifier = :parm_EB_SSN
ORDER BY
    ppa.effective_date;
