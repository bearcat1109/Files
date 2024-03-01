SELECT
    --'Optometry'         AS building,
    ssrmeet_bldg_code AS bldg,
    ssrmeet_room_code AS room,
    ssrmeet_term_code
    || '.'
    || ssrmeet_crn    AS class,
    CASE
        WHEN ssrmeet_begin_time IS NULL THEN
            NULL
        WHEN TO_NUMBER(substr(ssrmeet_begin_time, 0, 2)) > 12 THEN
            'PM '
            || '0'
            || to_char(TO_NUMBER(substr(ssrmeet_begin_time, 0, 2)) - 12)
            || ':'
            || substr(ssrmeet_begin_time, 3, 2)
        WHEN substr(ssrmeet_begin_time, 0, 2) = '12'          THEN
            'PM '
            || substr(ssrmeet_begin_time, 0, 2)
            || ':'
            || substr(ssrmeet_begin_time, 3, 2)
        ELSE
            'AM '
            || substr(ssrmeet_begin_time, 0, 2)
            || ':'
            || substr(ssrmeet_begin_time, 3, 2)
    END               starts,
    CASE
        WHEN ssrmeet_end_time IS NULL THEN
            NULL
        WHEN TO_NUMBER(substr(ssrmeet_end_time, 0, 2)) > 12 THEN
            'PM '
            || '0'
            || to_char(TO_NUMBER(substr(ssrmeet_end_time, 0, 2)) - 12)
            || ':'
            || substr(ssrmeet_end_time, 3, 2)
        WHEN substr(ssrmeet_end_time, 0, 2) = '12'          THEN
            'PM '
            || substr(ssrmeet_end_time, 0, 2)
            || ':'
            || substr(ssrmeet_end_time, 3, 2)
        ELSE
            'AM '
            || substr(ssrmeet_begin_time, 0, 2)
            || ':'
            || substr(ssrmeet_end_time, 3, 2)
    END               ends
FROM
    ssrmeet
WHERE
        ssrmeet_term_code = 202430
    AND (ssrmeet_bldg_code = 'OPT' OR ssrmeet_bldg_code = 'OPTCEL')
    AND sysdate BETWEEN ssrmeet_start_date AND ssrmeet_end_date
    AND ssrmeet_begin_time IS NOT NULL
    AND ssrmeet_tue_day IS NOT NULL
ORDER BY
    2,
    4;
