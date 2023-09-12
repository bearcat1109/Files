--Original instructions at   https://gitlab.nsuok.edu/NSU-Enterprise/helpful-sql/-/blob/prod/directory.sql
--Search to see if user exists
select 
    spriden_pidm
    , nsu_directory.directory_location.locationid
    , nsu_directory.directory_location.pidm
    , nsu_directory.directory_location.campus
    , nsu_directory.directory_location.building
    , nsu_directory.directory_location.office
    , nsu_directory.directory_location.extension
    , nsu_directory.directory_location.displayorder
from 
    spriden 
    left join nsu_directory.directory_location on 
        spriden_pidm = pidm
where
     spriden_id='N00059077'
     and spriden_change_ind is null;
    
    
--Find building abbreviation. 
select * from nsu_directory.phone_building order by abbrev;    
--Insert new record if it does not exist. Campus is T,B, or M one character. 
insert into nsu_directory.directory_location (pidm, campus, building, office, extension, displayorder) values ('', '', '', '', '', 1);
--Update person. Make sure to use where pidm =  or it will overwrite all records.
update nsu_directory.directory_location set extension = '6536', office = '230' where pidm=55990;
--Don't forget to commit if all looks correct
