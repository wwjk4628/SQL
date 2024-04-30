--1
SELECT
    COUNT(manager_id)
FROM
    employees;
--2
SELECT
    MAX(salary)               AS "최고임금",
    MIN(salary)               AS "최저임금",
    MAX(salary) - MIN(salary) AS "최고임금 - 최저임금"
FROM
    employees;
--3
SELECT
    to_char(
        MAX(hire_date), 'YYYY"년" MM"월" DD"일"'
    )
FROM
    employees;
--4
SELECT
    department_id,
    round(
        AVG(salary), 1
    ),
    MAX(salary),
    MIN(salary)
FROM
    employees
GROUP BY
    department_id
ORDER BY
    department_id DESC;

SELECT DISTINCT
    department_id,
    round(
        AVG(salary)
        OVER(PARTITION BY department_id), 0
    )                                AS 평균,
    MAX(salary)
    OVER(PARTITION BY department_id) AS 최대,
    MIN(salary)
    OVER(PARTITION BY department_id) AS 최소
FROM
    employees
ORDER BY
    1 DESC;

SELECT DISTINCT
    department_id,
    concat(
        '부서 ', department_id
    ) AS 부서,
    concat(
        round(
            AVG(salary)
            OVER(PARTITION BY department_id), 0
        ), '원'
    ) AS 평균,
    concat(
        MAX(salary)
        OVER(PARTITION BY department_id), '원'
    ) AS 최대,
    concat(
        MIN(salary)
        OVER(PARTITION BY department_id), '원'
    ) AS 최소
FROM
    employees
ORDER BY
    department_id DESC;

--5
SELECT
    round(
        AVG(salary), 1
    ),
    MAX(salary),
    MIN(salary),
    job_id
FROM
    employees
GROUP BY
    job_id
ORDER BY
    MIN(salary) DESC,
    AVG(salary) ASC;
--6
SELECT
    to_char(
        MIN(hire_date), 'YYYY-MM-DD DAY'
    )
FROM
    employees;

SELECT
    to_char(
        MIN(hire_date), 'YYYY-MM-DD DAY'
    )
FROM
    employees
WHERE
    employee_id NOT IN (
        SELECT
            employee_id
        FROM
            job_history
    );
--7
SELECT
    nvl(
        department_id, 1
    ),
    round(
        AVG(salary), 1
    ) 평균임금,
    MIN(salary),
    round(
        AVG(salary) - MIN(salary), 1
    ) "평균임금 - 최저임금"
FROM
    employees
GROUP BY
    department_id
HAVING
    AVG(salary) - MIN(salary) < 2000
ORDER BY
    AVG(salary) - MIN(salary) DESC;

--8
SELECT
    job_title,
    max_salary - min_salary
FROM
    jobs
ORDER BY
    2 DESC;

--9

SELECT
    MIN(salary),
    MAX(salary),
    round(
        AVG(salary), 0
    ),
    manager_id
FROM
    employees
WHERE
    manager_id IS NOT NULL
    AND hire_date > TO_DATE('20150101', 'YYYYMMDD')
GROUP BY
    manager_id
HAVING
    AVG(salary) >= 5000
ORDER BY
    3 DESC;
--10
SELECT
    employee_id,
    first_name,
    hire_date,
    CASE
    WHEN hire_date <= TO_DATE('20121231', 'YYYYMMDD') THEN
    '창립맴버'
    WHEN hire_date <= TO_DATE('20131231', 'YYYYMMDD') THEN
    '13년입사'
    WHEN hire_date <= TO_DATE('20141231', 'YYYYMMDD') THEN
    '14년입사'
    ELSE
    '상장이후입사'
    END AS optdate
FROM
    employees
ORDER BY
    hire_date;

SELECT
    employee_id,
    first_name,
    hire_date,
    CASE
    WHEN hire_date <= '20121231' THEN
    '창립맴버'
    WHEN hire_date <= '20131231' THEN
    '13년입사'
    WHEN hire_date <= '20141231' THEN
    '14년입사'
    ELSE
    '상장이후입사'
    END AS optdate
FROM
    employees
ORDER BY
    hire_date;