-- Student/Employee combination combined by Gabriel Berres 11-1-2023

select distinct
	spriden_first_name as FIRSTNAME,
	spriden_last_name as LASTNAME,
	spriden_mi as SPRIDEN_MI,
	spriden_first_name ||' '|| spriden_last_name as DISPLAYNAME,
	lower((gobtpac.gobtpac_external_user || '@nsuok.edu')) as NSU_EMAIL,
	lower(gobtpac.gobtpac_external_user) NSU_USERID,
	gobumap_udc_id as IMMUTABLEID
from
	gobtpac
join spriden on
	spriden_change_ind is null
	and spriden_pidm = gobtpac_pidm
inner join gobumap on
	gobtpac.gobtpac_pidm = gobumap.gobumap_pidm
inner join goremal on
	goremal_pidm = gobumap.gobumap_pidm and goremal_emal_code = 'NSU'
inner join pebempl on
	pebempl_pidm = gobtpac_pidm
where
	substr(spriden_last_name,1,3) <> 'DNU'
	and lower(gobtpac_external_user) not like 'N00%'
	and (pebempl_last_work_date is null or pebempl_last_work_date > sysdate - 1)
    and gb_integ_config.f_exists('ELEARNING',
                                 'LDIEMPEX',
                                 pebempl_ecls_code) = 'N'
    and pebempl_empl_status <> 'T'
    -- Extra filtering 11-2-2023, remove retirees
    AND pebempl_ecls_code NOT IN ('90', '92', '99')
    
UNION 
(
select distinct
    spriden_first_name as FIRSTNAME,
    spriden_last_name as LASTNAME,
    spriden_mi as SPRIDEN_MI,
    spriden_first_name ||' '|| spriden_last_name as DISPLAYNAME,
    lower((gobtpac.gobtpac_external_user || '@nsuok.edu')) as NSU_EMAIL,
    gobtpac_external_user as NSU_USERID,
    gobumap_udc_id as IMMUTABLEID
from
    sgbstdn
inner join stvstst on
    sgbstdn_stst_code = stvstst_code
    and stvstst_reg_ind = 'Y'
inner join gobtpac on
    sgbstdn_pidm = gobtpac_pidm
inner join spriden on
    spriden_pidm = gobtpac_pidm
inner join gobumap on
    gobtpac.gobtpac_pidm = gobumap.gobumap_pidm
inner join goremal on
    goremal_pidm = gobumap.gobumap_pidm
    and goremal_emal_code = 'NSU'
where
    (sgbstdn_term_code_eff like extract(year from sysdate) || '%'
     or sgbstdn_term_code_eff like extract(year from sysdate) - 2 || '%'
     or sgbstdn_term_code_eff like extract(year from sysdate) - 1 || '%'
     or sgbstdn_term_code_eff like extract(year from sysdate) + 1 || '%')
     and spriden_change_ind is null
     and spriden_last_name not like '%DO%NOT%USE%'
     and spriden_entity_ind = 'P'
     and spriden_id like 'N%'

union

select distinct
    spriden_first_name as firstname,
    spriden_last_name as lastname,
    spriden_mi,
    spriden_first_name ||' '|| spriden_last_name as displayname,
    lower((gobtpac.gobtpac_external_user || '@nsuok.edu')) as nsu_email,
    gobtpac_external_user as nsu_userid,
    gobumap_udc_id as immutableid
from
    gobtpac
inner join sfrstcr on
    gobtpac_pidm = sfrstcr_pidm
    and (sfrstcr_term_code like extract(year from sysdate) || '%'
         or sfrstcr_term_code like extract(year from sysdate) - 2 || '%'
         or sfrstcr_term_code like extract(year from sysdate) - 1 || '%'
         or sfrstcr_term_code like extract(year from sysdate) + 1 || '%')
    and sfrstcr_rsts_code in (select
                                  stvrsts_code
                              from
                                  stvrsts
                              where
                                  stvrsts_code = 'RE'
                                  or stvrsts_code = 'RW'
                                  or stvrsts_code = 'RF'
                                  or stvrsts_code = 'RA'
                                  or stvrsts_code = 'AU')
inner join spriden on
    spriden_pidm = gobtpac_pidm
inner join gobumap on
    gobtpac.gobtpac_pidm = gobumap.gobumap_pidm
inner join goremal on
    goremal_pidm = gobumap.gobumap_pidm
    and goremal_emal_code = 'NSU'
JOIN sfbetrm ON
    sfbetrm_pidm = gobtpac_pidm
where
    spriden_change_ind is null
    and spriden_last_name not like '%DO%NOT%USE%'
    and spriden_entity_ind = 'P'
    and spriden_id like 'N%'
    -- Added 11-2-2023, current term or last enrollment within 2 months
    AND (sfbetrm_term_code IN
        (
            SELECT 
                stvterm_code
            FROM 
                stvterm
            WHERE
                stvterm_code >= (
                SELECT MAX(stvterm_code)
                FROM 
                    stvterm
                WHERE 
                    sysdate < stvterm_end_date
                AND sysdate > stvterm_start_date
                AND stvterm_code NOT LIKE '%9'))
         OR sfbetrm_activity_date > sysdate - 60
)
)
;
