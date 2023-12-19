SELECT DISTINCT
    room,
    term_code,
    COUNT(room)
    OVER(PARTITION BY room, term_code) num_classes
FROM
    (
        SELECT
            ssrmeet_term_code    term_code,
            ssrmeet_bldg_code
            || ' '
            || ssrmeet_room_code AS room
        FROM
            ssrmeet
        WHERE
            ssrmeet_bldg_code
            || ' '
            || ssrmeet_room_code IN ( 'WEBB 207', 'WEBB 307', 'BT 126', 'BT 128', 'BT 129',
                                      'BT B8', 'SC 270', 'SC LL046', 'BAGLEY 327', 'SS 106',
                                      'FITCTR 205', 'WILSON G18', 'WILSON 415', 'BABT 129', 'BAED 113',
                                      'BALA 118', 'BALA 130', 'BALB 106', 'BALB 110', 'BALA 230',
                                      'BALA 234', 'NSM 209', 'SYNAR 205',
                                      -- Added 12-19-2023
                                      'BAED 129', 'BAED 209', 'BASC 249', 'FA 201', 'LIB 118A', 'WILSON 238'
                                      )
    )
WHERE
    term_code IN ('202420', '202410', '202330')
--    (SELECT DISTINCT MAX(stvterm_code)
--            FROM stvterm
--            WHERE stvterm_start_date < sysdate
--            AND stvterm_desc NOT LIKE 'CE%'
--    );
ORDER BY
    term_code ASC
;
