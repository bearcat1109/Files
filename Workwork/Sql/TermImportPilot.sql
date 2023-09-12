-- Written 8-28-2023 by Gabriel Berres, Term Import Pilot. Limited to current term
select distinct
    stvterm_code Term_Code,
    stvterm_desc Term_Name,
    to_char(stvterm_start_date, 'DD/MM/YYYY') Start_Date,
    to_char(stvterm_end_date, 'DD/MM/YYYY') End_Date
from stvterm
where stvterm_code > '202320' AND stvterm_code != '999999';