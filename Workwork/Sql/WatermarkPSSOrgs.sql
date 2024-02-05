SELECT
    'Academic Affairs'              name,
    'AA'                            id,
    'Division'                      type,
    'Northeastern State Univeristy' parent
FROM
    dual
UNION ALL
SELECT
    stvcoll_desc,
    stvcoll_code,
    'College',
    'AA'
FROM
    stvcoll
WHERE
    stvcoll_code NOT IN ( '99', 'AA' )
UNION ALL
SELECT
    stvdept_desc,
    stvdept_code,
    'Department',
    CASE
        WHEN stvdept_code IN ( 'EFL', 'CI', 'HK', 'PSYC' ) THEN
            'ED'
        WHEN stvdept_code IN ( 'BADM', 'AF' ) THEN
            'BT'
        WHEN stvdept_code IN ( 'CE' ) THEN
            'CE'
        WHEN stvdept_code IN ( 'CHIS', 'CMS', 'CJG', 'GPOL', 'HIST',
                               'LANG', 'SOWK', 'PART', 'AD', 'MUS',
                               'AT', 'USMS', 'CRJ' ) THEN
            'LA'
        WHEN stvdept_code IN ( 'HP', 'MCS', 'NSCI' ) THEN
            'SH'
        WHEN stvdept_code IN ( 'OPT' ) THEN
            'OP'
        ELSE
            '00'
    END
FROM
    stvdept
WHERE
    stvdept_code NOT IN ( 'MGMK', 'GPSS', 'IST', 'COMM', 'SSCI',
                          'MHSC', 'TED' );
