--혼합 SQL 문제입니다.
--문제1.
--담당 매니저가 배정되어있으나 커미션비율이 없고, 월급이 3000초과인 직원의
--이름, 매니저 아이디, 커미션 비율, 월급을 출력하세요.
--(45건)

SELECT
    e.first_name,
    e.manager_id,
    e.commission_pct,
    e.salary
FROM
    employees e
    JOIN employees m ON e.manager_id = m.employee_id
WHERE
    e.commission_pct IS NULL
    AND e.salary > 3000;

--문제2.
--각 부서별로 최고의 급여를 받는 사원의 직원번호(employee_id), 이름(first_name), 급여
--(salary), 입사일(hire_date), 전화번호(phone_number), 부서번호(department_id)를 조회하세
--요
---조건절 비교 방법으로 작성하세요
---급여의 내림차순으로 정렬하세요
---입사일은 2001-01-13 토요일 형식으로 출력합니다.
---전화번호는 515-123-4567 형식으로 출력합니다.
--(11건)

SELECT
    employee_id,
    first_name,
    salary,
    to_char(
        hire_date, 'YYYY-MM-DD DAY'
    ),
    translate(
        phone_number, '.', '-'
    ),
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
    );

--문제3
--매니저별로 평균급여 최소급여 최대급여를 알아보려고 한다.
---통계대상(직원)은 2015년 이후의 입사자 입니다.
---매니저별 평균급여가 5000이상만 출력합니다.
---매니저별 평균급여의 내림차순으로 출력합니다.
---매니저별 평균급여는 소수점 첫째자리에서 반올림 합니다.
---출력내용은 매니저 아이디, 매니저이름(first_name), 매니저별 평균급여, 매니저별 최소급여,
--매니저별 최대급여 입니다.
--(9건)
SELECT
    r.first_name,
    t.*
FROM
    employees r
    JOIN (
        SELECT
            manager_id  abc,
            round(
                AVG(salary), 0
            )           avg_sal,
            MAX(salary) max_sal,
            MIN(salary) min_sal
        FROM
            (
                SELECT
                    *
                FROM
                    employees
                WHERE
                    hire_date >= '20160101'
            )
        WHERE
            manager_id IS NOT NULL
        GROUP BY
            manager_id
    ) t ON r.employee_id = t.abc
WHERE
    avg_sal >= 5000
    ORDER BY avg_sal DESC;
----------------------------------------------------------------
-----------------------------------------------------------------
SELECT DISTINCT
    *
FROM
    (
        SELECT DISTINCT
            e1.manager_id,
            m.first_name                     이름,
            round(
                AVG(e1.salary)
                OVER(PARTITION BY e1.manager_id), 0
            )                                평균,
            MAX(e1.salary)
            OVER(PARTITION BY e1.manager_id) 최대,
            MIN(e1.salary)
            OVER(PARTITION BY e1.manager_id) 최소
        FROM
            employees e1
            JOIN employees m ON e1.manager_id = m.employee_id
        WHERE
            e1.hire_date >= '20160101'
    )
WHERE
    평균 >= 5000
    ORDER BY 평균 DESC;
    --------------------------------------------------------------------------
    SELECT
    DISTINCT *
FROM
    (
        SELECT
            emp.manager_id                                    "매니저 아이디",
            mng.first_name                                       "매니저 이름",
            round(avg(emp.salary) OVER (PARTITION BY emp.manager_id), 0) "매니저 평균급여",
            MIN(emp.salary) OVER (PARTITION BY emp.manager_id)           "매니저 최소급여",
            MAX(emp.salary) OVER (PARTITION BY emp.manager_id)           "매니저 최대급여"
        FROM
            employees emp
            JOIN employees mng
            ON emp.manager_id = mng.employee_id
        WHERE
            emp.hire_date >= TO_DATE('20160101', 'yyyymmdd')
        
    )
WHERE
    "매니저 평균급여" >= 5000
ORDER BY
    "매니저 평균급여" DESC;
----------------------------------------------------------------------
--문제4.
--각 사원(employee)에 대해서 사번(employee_id), 이름(first_name), 부서명
--(department_name), 매니저(manager)의 이름(first_name)을 조회하세요.
--부서가 없는 직원(Kimberely)도 표시합니다.
--(106명)
SELECT
    e.employee_id,
    e.first_name,
    d.department_name,
    m.first_name
FROM
    employees e
    JOIN employees   m ON e.manager_id = m.employee_id
    LEFT OUTER JOIN departments d ON e.department_id = d.department_id;


--문제5.
--2015년 이후 입사한 직원 중에 입사일이 11번째에서 20번째의 직원의
--사번, 이름, 부서명, 급여, 입사일을 입사일 순서로 출력하세요

SELECT
    employee_id 사번,
    first_name  이름,
    department_name,
    salary      급여,
    e.hire_date 입사일
FROM
    employees e
    JOIN (
        SELECT
            employee_id,
            hire_date,
            ROW_NUMBER()
            OVER(
                ORDER BY
                    hire_date
            ) rn
        FROM
            employees
        WHERE
            hire_date >= '20160101'
    ) USING ( employee_id )
    JOIN departments USING ( department_id )
WHERE
    rn BETWEEN 11 AND 20;

--문제6.
--가장 늦게 입사한 직원의 이름(first_name last_name)과 연봉(salary)과 근무하는 부서 이름
--(department_name)은?
SELECT
    first_name
    || ' '
    || last_name,
    salary,
    department_name
FROM
    employees
    JOIN departments USING ( department_id )
WHERE
    hire_date = (
        SELECT
            MAX(hire_date)
        FROM
            employees
    );
--문제7.
--평균연봉(salary)이 가장 높은 부서 직원들의 직원번호(employee_id), 이름(firt_name), 성
--(last_name)과 업무(job_title), 연봉(salary)을 조회하시오.
SELECT
    employee_id,
    first_name,
    last_name,
    job_title,
    salary * 12,
    avg
FROM
    employees e
    JOIN (
        SELECT
            AVG(salary) avg,
            department_id
        FROM
            employees
        GROUP BY
            department_id
    )    a ON e.department_id = a.department_id
    JOIN jobs j ON e.job_id = j.job_id
WHERE
    avg = (
        SELECT
            MAX(avg)
        FROM
            employees e
            JOIN (
                SELECT
                    AVG(salary) avg,
                    department_id
                FROM
                    employees
                GROUP BY
                    department_id
            ) a ON e.department_id = a.department_id
    );

SELECT
    avg,
    department_id,
    department_name
FROM
    (
        SELECT
            AVG(salary) avg,
            department_id
        FROM
            employees
        GROUP BY
            department_id
    )
    JOIN departments USING ( department_id );
--문제8.
--평균 급여(salary)가 가장 높은 부서는?
SELECT DISTINCT
    a.department_name
FROM
    employees e
    JOIN (
        SELECT
            avg,
            department_id,
            department_name
        FROM
            (
                SELECT
                    AVG(salary) avg,
                    department_id
                FROM
                    employees
                GROUP BY
                    department_id
            )
            JOIN departments USING ( department_id )
    ) a ON e.department_id = a.department_id
WHERE
    avg = (
        SELECT
            MAX(avg)
        FROM
            employees e
            JOIN (
                SELECT
                    AVG(salary) avg,
                    department_id
                FROM
                    employees
                GROUP BY
                    department_id
            ) a ON e.department_id = a.department_id
    );

--문제9.
--평균 급여(salary)가 가장 높은 지역은?
--SELECT
--    MAX(avg)
--FROM
--    (
--        SELECT
--            AVG(salary) avg,
--            location_id
--        FROM
--            employees
--            JOIN departments USING ( department_id )
--            JOIN locations USING ( location_id )
--        GROUP BY
--            location_id
--    );
------------------------------------------------------------------
SELECT DISTINCT
    r.region_name
FROM
    employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN (
        SELECT
            AVG(salary) avg,
            location_id
        FROM
            employees
            JOIN departments USING ( department_id )
            JOIN locations USING ( location_id )
        GROUP BY
            location_id
    )           a ON d.location_id = a.location_id
    JOIN locations   l ON a.location_id = l.location_id
    JOIN countries   c ON l.country_id = c.country_id
    JOIN regions     r ON c.region_id = r.region_id
WHERE
    avg = (
        SELECT
            MAX(avg)
        FROM
            (
                SELECT
                    AVG(salary) avg,
                    location_id
                FROM
                    employees
                    JOIN departments USING ( department_id )
                    JOIN locations USING ( location_id )
                GROUP BY
                    location_id
            )
    );

--문제10.
--평균 급여(salary)가 가장 높은 업무는?
SELECT
    j.job_title
FROM
    employees e
    JOIN (
        SELECT
            AVG(salary) avg,
            job_id
        FROM
            employees
        GROUP BY
            job_id
    )    a ON e.job_id = a.job_id
    JOIN jobs j ON e.job_id = j.job_id
WHERE
    avg = (
        SELECT
            MAX(avg)
        FROM
            employees e
            JOIN (
                SELECT
                    AVG(salary) avg,
                    job_id
                FROM
                    employees
                GROUP BY
                    job_id
            ) a ON e.job_id = a.job_id
    );

------------------------------------------------------------------

--SELECT DISTINCT
--    j.job_title
--FROM
--    employees e
--    JOIN (
--        SELECT
--            AVG(salary) avg,
--            job_id
--        FROM
--            employees
--        GROUP BY
--            job_id
--    )    a ON e.job_id = a.job_id
--    JOIN jobs j ON e.job_id = j.job_id
--WHERE
--    avg = (
--        SELECT
--            MAX(avg)
--        FROM
--            employees e
--            JOIN (
--                SELECT
--                    AVG(salary) avg,
--                    department_id
--                FROM
--                    employees
--                GROUP BY
--                    department_id
--            ) a ON e.department_id = a.department_id
--    );