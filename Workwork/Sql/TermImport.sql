-- Written 8-28-2023 by Gabriel Berres, SLL Term Import
select distinct
    stvterm_code Term_Code,
    stvterm_desc Term_Name,
    to_char(stvterm_start_date, 'DD/MM/YYYY') Start_Date,
    to_char(stvterm_end_date, 'DD/MM/YYYY') End_Date
from stvterm
where stvterm_code > '202320' AND stvterm_code != '999999';



-- Written 8-28-2023 by Gabriel Berres, SLL Term Import
-- Updated 1/23/2024 Programmers + Rob
select distinct
    stvterm_code Term_Code,
    CASE
        WHEN substr(stvterm_code, 5, 2) = 30 THEN
            substr(stvterm_code, 0, 4)
        ELSE
            to_char(substr(stvterm_code, 0, 4) - 1)
    END
    || ' '
    ||     CASE
        WHEN substr(stvterm_code, 5, 2) = 10 THEN
            'Summer'
        WHEN substr(stvterm_code, 5, 2) = 20 THEN
            'Fall'
        WHEN substr(stvterm_code, 5, 2) = 30 THEN
            'Spring'
    END Term_Name,
    to_char((stvterm_start_date - 28), 'DD/MM/YYYY' ) Start_Date,
    to_char(stvterm_end_date, 'DD/MM/YYYY') End_Date
from stvterm
where stvterm_code > '202320' AND stvterm_code != '999999'
