select * from ssrmeet 
where ssrmeet_bldg_code || ' ' || ssrmeet_room_code = 'BABT 129';

select distinct 
    ssrmeet_bldg_code || ' ' || ssrmeet_room_code Room,
    CASE 
        WHEN
    ssrmeet_term_code = 202420
        THEN 
        'FALL 2023'
        WHEN 
    ssrmeet_term_code = 202410
        THEN 
        'SUMMER 2023'
        WHEN 
    ssrmeet_term_code = 202330
        THEN 
        'SPRING 2023'
        ELSE
        ''
    END AS Term
from ssrmeet where ssrmeet_term_code IN ('202420', '202410', '202330')
ORDER BY Room Asc;
