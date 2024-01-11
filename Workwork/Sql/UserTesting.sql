WITH w_gorrace AS 
(
    SELECT 
        gorprac_pidm            w_gorrace_pidm,
        COUNT(*) OVER (PARTITION BY gorprac_pidm) w_gorrace_rowct
    FROM 
        gorprac
        JOIN gorrace ON gorrace_race_cde = gorprac_race_cde
    WHERE 
        length(gorprac_race_cde) = 1
)

SELECT DISTINCT 
    spriden_id,
    CASE
        WHEN spbpers_ethn_code = 1 THEN
            'Other'
        WHEN spbpers_ethn_code = 2 THEN
            'Black Non-Hispanic'
        WHEN spbpers_ethn_code = 3 THEN
            'Am. Indian or Alaskan Native'
        WHEN spbpers_ethn_code = 4 THEN
            'Asian or Pacific Islander'
        WHEN spbpers_ethn_code = 5 THEN
            'Hispanic'
        WHEN spbpers_ethn_code = 6 THEN
            'White Non-Hispanic'
        WHEN spbpers_ethn_code = 7 THEN
            'Asian or Pacific Islander'
        WHEN spbpers_ethn_code = 8 THEN
            'Other'
        ELSE
            'Other'
    END                                   AS "Race_Details_Spbpers",
        CASE
        WHEN gorprac_race_cde = 1 THEN
            'Other'
        WHEN gorprac_race_cde = 2 THEN
            'Black Non-Hispanic'
        WHEN gorprac_race_cde = 3 THEN
            'Am. Indian or Alaskan Native'
        WHEN gorprac_race_cde = 4 THEN
            'Asian or Pacific Islander'
        WHEN gorprac_race_cde = 5 THEN
            'Hispanic'
        WHEN gorprac_race_cde = 6 THEN
            'White Non-Hispanic'
        WHEN gorprac_race_cde = 7 THEN
            'Asian or Pacific Islander'
        WHEN gorprac_race_cde = 8 THEN
            'Other'
        ELSE
            'Other'
        END AS                  race_details_gorprac,
--        CASE
--            WHEN
--        gorrace_race_cde < 2
--            THEN
--            'Am. Indian or Alaskan Native' 
--            WHEN
--        gorrace_race_cde = 2 
--            THEN 
--            'Black Non-Hispanic'
--            WHEN
--        gorrace_race_cde > 2 AND gorrace_race_cde > 3
--            THEN
--            'Asian or Pacific Islander'
--            WHEN
--        gorrace_race_cde = 3 
--            THEN
--            'Am. Indian or Alaskan Native'
--            WHEN 
--        gorrace_race_cde > 3 AND gorrace_race_cde < 4
    CASE 
        WHEN 
            w_gorrace_rowct > 1 
        THEN 
            'Y'
        ELSE
            'N'
        END AS TwoMoreRaces,
    CASE 
        WHEN
            w_gorrace_rowct > 1
        THEN 
            'Two or more races'
        WHEN
            gorrace_race_cde = 2
        THEN
            'Black or African American'
        WHEN
            gorrace_race_cde = 3
        THEN
            'American Indian or Alaskan Native'
        WHEN
            gorrace_race_cde = 4
        THEN
            'Asian'
        WHEN
            gorrace_race_cde = 5
        THEN
            'Hispanic or Latino'
        WHEN
            gorrace_race_cde = 6
        THEN
            'White'
        WHEN
            gorrace_race_cde = 7 
        THEN
            'Native Hawaiian or other Pacific Islander'
        WHEN
            gorrace_race_cde = 8
        THEN
            'Not Specified / Declined to Specify'
        ELSE 
            'Not Specified / Declined to Specify'
        END RaceEthnicityNew
FROM 
    spriden 
    JOIN spbpers ON spbpers_pidm = spriden_pidm
    JOIN gorprac ON gorprac_pidm = spriden_pidm
    JOIN gorrace ON gorrace_race_cde = gorprac_race_cde
    JOIN w_gorrace ON w_gorrace_pidm = spriden_pidm;
    
    
  select * from gorprac where gorprac_pidm = 119450;  
  select * from gorrace order by gorrace_race_cde asc;
