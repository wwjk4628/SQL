--문제1.
--평균 급여보다 적은 급여을 받는 직원은 몇명인지 구하시요.
--(56건)
SELECT
    AVG(salary)
FROM
    employees;

SELECT
    COUNT(*)
FROM
    employees
WHERE
    salary < (
        SELECT
            AVG(salary) AS avg
        FROM
            employees
    );
--문제2.
--평균급여 이상, 최대급여 이하의 월급을 받는 사원의
--직원번호(employee_id), 이름(first_name), 급여(salary), 평균급여, 최대급여를 급여의 오름차
--순으로 정렬하여 출력하세요
--(51건)
SELECT
    employee_id,
    first_name,
    last_name,
    salary
FROM
    employees
WHERE
    salary >= (
        SELECT
            AVG(salary)
        FROM
            employees
    )
INTERSECT
SELECT
    employee_id,
    first_name,
    last_name,
    salary
FROM
    employees
WHERE
    salary <= (
        SELECT
            MAX(salary)
        FROM
            employees
    );
----------------------------------------------------------
SELECT
    employee_id,
    first_name,
    salary,
    round(
        a.avg, 1
    ),
    m.ma
FROM
    employees,
    (
        SELECT
            AVG(salary) AS avg
        FROM
            employees
    ) a,
    (
        SELECT
            MAX(salary) AS ma
        FROM
            employees
    ) m
WHERE
    salary > a.avg
    AND salary <= m.ma
ORDER BY
    salary;
------------------------------------------------------------------
SELECT
    e.employee_id,
    e.first_name,
    e.salary,
    t.avgsalary,
    t.maxsalary
FROM
    employees e
    JOIN (
        SELECT
            round(
                AVG(salary), 0
            )           avgsalary,
            MAX(salary) maxsalary
        FROM
            employees
    ) t ON e.salary BETWEEN t.avgsalary AND t.maxsalary
ORDER BY
    salary;

--문제3.
--직원중 Steven(first_name) king(last_name)이 소속된 부서(departments)가 있는 곳의 주소
--를 알아보려고 한다.
--도시아이디(location_id), 거리명(street_address), 우편번호(postal_code), 도시명(city), 주
--(state_province), 나라아이디(country_id) 를 출력하세요
--(1건)
SELECT
    l.location_id,
    l.street_address,
    l.postal_code,
    l.city,
    l.state_province,
    l.country_id
FROM
    employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations   l ON d.location_id = l.location_id
WHERE
    e.first_name LIKE 'Steven'
    AND e.last_name LIKE 'King';
-----------------------------------------------------------------
SELECT
    location_id,
    street_address,
    postal_code,
    city,
    state_province,
    country_id
FROM
    locations
    NATURAL JOIN departments    --  location_id 로 JOIN
    JOIN employees USING ( department_id )
WHERE
    first_name = 'Steven'
    AND last_name = 'King';
-----------------------------------------------------------------
SELECT
    l.location_id,
    l.street_address,
    l.postal_code,
    l.city,
    l.state_province,
    l.country_id
FROM
    locations l
    JOIN departments d ON d.location_id = l.location_id
    JOIN (
        SELECT
            department_id,
            first_name,
            last_name
        FROM
            employees
        WHERE
            first_name LIKE 'Steven'
            AND last_name LIKE 'King'
    )           a ON d.department_id = a.department_id;
    
    
-------------------------------------------------------------------------
SELECT
    location_id,
    street_address,
    postal_code,
    city,
    state_province,
    country_id
FROM
    locations
WHERE
    location_id = (
        SELECT
            location_id
        FROM
            departments
        WHERE
            department_id = (
                SELECT
                    department_id
                FROM
                    employees
                WHERE
                    first_name = 'Steven'
                    AND last_name = 'King'
            )
    );
--문제4.
--job_id 가 'ST_MAN' 인 직원의 급여보다 작은 직원의 사번,이름,급여를 급여의 내림차순으로
--출력하세요 -ANY연산자 사용
--(74건)
--SELECT
--    salary
--FROM
--    employees
--WHERE
--    job_id = 'ST_MAN';

SELECT
    employee_id,
    first_name,
    salary
FROM
    employees
WHERE
    salary < ANY (
        SELECT
            salary
        FROM
            employees
        WHERE
            job_id = 'ST_MAN'
    )
ORDER BY
    salary DESC;

--문제5.
--각 부서별로 최고의 급여를 받는 사원의 직원번호(employee_id), 이름(first_name)과 급여
--(salary) 부서번호(department_id)를 조회하세요
--단 조회결과는 급여의 내림차순으로 정렬되어 나타나야 합니다.
--조건절비교, 테이블조인 2가지 방법으로 작성하세요
--(11건)
--SELECT employee_id, first_name, salary, department_id
--FROM employees
--WHERE (salary, department_id) IN
--(SELECT MAX(salary), department_id
--FROM employees
--GROUP BY department_id);

SELECT
    e.employee_id,
    e.first_name,
    e.salary,
    e.department_id
FROM
    employees e
    JOIN (
        SELECT
            department_id,
            MAX(salary) m
        FROM
            employees
        GROUP BY
            department_id
    ) a ON e.department_id = a.department_id
           AND e.salary = a.m
ORDER BY
    3 DESC;
-------------------------------------------------------------------------------------------
SELECT
    employee_id,
    first_name,
    salary,
    department_id
FROM
    employees
WHERE
    ( department_id, salary ) IN (
        SELECT
            department_id, MAX(salary)
        FROM
            employees
        GROUP BY
            department_id
    )
ORDER BY
    3 DESC;


--문제6.
--각 업무(job) 별로 연봉(salary)의 총합을 구하고자 합니다.
--연봉 총합이 가장 높은 업무부터 업무명(job_title)과 연봉 총합을 조회하시오
--(19건)
SELECT
    job_id,
    job_title,
    SUM(salary)
FROM
    employees
    JOIN jobs USING ( job_id )
GROUP BY
    job_id,
    job_title;

--SELECT
--    job_id,
--    SUM(salary)
--FROM
--    employees
--GROUP BY
--    job_id;
-----------------------------------------------------------------
SELECT
    (
        SELECT
            job_title
        FROM
            jobs
        WHERE
            e.job_id = job_id
    ),
    SUM(salary)
FROM
    employees e
GROUP BY
    job_id;
-------------------------------------------------------------
SELECT
    job_title,
    (
        SELECT
            SUM(salary)
        FROM
            employees
        WHERE
            job_id = j.job_id
    ) 합
FROM
    jobs j;

----------------------------------------------------------------
SELECT
    job_title,
    a.sum_sal,
    job_id
FROM
    jobs
    JOIN (
        SELECT
            job_id,
            SUM(salary) sum_sal
        FROM
            employees
        GROUP BY
            job_id
    ) a USING ( job_id )
ORDER BY
    2 DESC;

--문제7.
--자신의 부서 평균 급여보다 연봉(salary)이 많은 직원의 직원번호(employee_id), 이름
--(first_name)과 급여(salary)을 조회하세요
--(38건)
SELECT
    employee_id,
    first_name,
    salary
FROM
    employees
    JOIN (
        SELECT
            department_id,
            AVG(salary) avg
        FROM
            employees
        GROUP BY
            department_id
    ) t USING ( department_id )
WHERE
    salary > t.avg;


----------------------------------------------
SELECT
    employee_id,
    first_name,
    salary
FROM
    employees e
WHERE
    salary > (
        SELECT
            AVG(salary)
        FROM
            employees
        WHERE
            department_id = e.department_id
    );


--문제8.
--직원 입사일이 11번째에서 15번째의 직원의 사번, 이름, 급여, 입사일을 입사일 순서로 출력
--하세요
SELECT
    rn,
    employee_id,
    first_name,
    salary,
    e.hire_date
FROM
    employees e
    JOIN (
        SELECT
            employee_id,
            ROW_NUMBER()
            OVER(
                ORDER BY
                    hire_date ASC
            ) AS rn
        FROM
            employees
    ) USING ( employee_id )
WHERE
    rn > 10
    AND rn < 16;
--------------------------

SELECT
    *
FROM
    (
        SELECT
            employee_id,
            first_name,
            salary,
            hire_date,
            ROW_NUMBER()
            OVER(
                ORDER BY
                    hire_date ASC
            ) AS rn
        FROM
            employees
    ) sub
WHERE
    rn < 16
    AND rn > 10;
    
-------------------------------------------------
--SELECT
--    ROWNUM rn,
--    employee_id,
--    first_name,
--    salary,
--    hire_date
--FROM
--    employees
--ORDER BY
--    hire_date;
-------------------------------------
SELECT
    *
FROM
    (
        SELECT
            ROWNUM rn,
            a.*
        FROM
            (
                SELECT
                    employee_id,
                    first_name,
                    salary,
                    hire_date
                FROM
                    employees
                ORDER BY
                    hire_date
            ) a
    )
WHERE
    rn >= 11
    AND rn <= 15;
-- 흐름이 FROM -> WHERE -> SELECT -> ORDER BY 순으로 흘러가서
-- 이미 ROWNUM이 hire_date로 정렬되기 전에 번호가 매겨져 위 코드로 짜야함