--문제1.
--직원들의 사번(employee_id), 이름(firt_name), 성(last_name)과 부서명(department_name)을
--조회하여 부서이름(department_name) 오름차순, 사번(employee_id) 내림차순 으로 정렬하세
--요.
--(106건)
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name
FROM
    employees   e,
    departments d
WHERE
    e.department_id = d.department_id
ORDER BY
    4 ASC,
    1 DESC;

-- ANSI
-- JOIN의 의도를 명확하게 하고, JOIN 조건과 SELECTION 조건을 분리하는 효과
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name
FROM
    employees e
    JOIN departments d ON e.department_id = d.department_id
ORDER BY
    4 ASC,
    1 DESC;

--문제2.
--employees 테이블의 job_id는 현재의 업무아이디를 가지고 있습니다.
--직원들의 사번(employee_id), 이름(firt_name), 급여(salary), 부서명(department_name), 현
--재업무(job_title)를 사번(employee_id) 오름차순 으로 정렬하세요.
--부서가 없는 Kimberely(사번 178)은 표시하지 않습니다.
--(106건)
SELECT
    e.employee_id,
    e.first_name,
    e.salary,
    d.department_name,
    j.job_title
FROM
    employees   e,
    departments d,
    jobs        j
WHERE
    e.department_id = d.department_id
    AND e.job_id = j.job_id
ORDER BY
    1 ASC;
---------------------------------------------------------------------
-- ANSI
---------------------------------------------------------------------
SELECT
    e.employee_id,
    e.first_name,
    e.salary,
    d.department_name,
    j.job_title
FROM
    employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN jobs        j ON e.job_id = j.job_id
ORDER BY
    1 ASC;

--문제2-1.
--문제2에서 부서가 없는 Kimberely(사번 178)까지 표시해 보세요
--(107건)
SELECT
    e.employee_id,
    e.first_name,
    e.salary,
    d.department_name,
    j.job_title
FROM
    employees   e,
    departments d,
    jobs        j
WHERE
    e.department_id = d.department_id (+)
    AND e.job_id = j.job_id
ORDER BY
    1 ASC;
-------------------------------------------
SELECT
    e.employee_id,
    e.first_name,
    e.salary,
    d.department_name,
    j.job_title
FROM
    employees   e
    LEFT OUTER JOIN departments d ON e.department_id = d.department_id
    JOIN jobs        j ON e.job_id = j.job_id
ORDER BY
    1 ASC;
--문제3.
--도시별로 위치한 부서들을 파악하려고 합니다.
--도시아이디, 도시명, 부서명, 부서아이디를 도시아이디(오름차순)로 정렬하여 출력하세요
--부서가 없는 도시는 표시하지 않습니다.
--(27건)
SELECT
    l.location_id     AS "도시아이디",
    l.city            AS "도시명",
    d.department_name AS "부서명",
    d.department_id   AS "부서아이디"
FROM
    locations   l,
    departments d
WHERE
    l.location_id = d.location_id
ORDER BY
    1 ASC;
----------------------------------------------
SELECT
    l.location_id     AS "도시아이디",
    l.city            AS "도시명",
    d.department_name AS "부서명",
    d.department_id   AS "부서아이디"
FROM
    locations l
    JOIN departments d ON l.location_id = d.location_id
ORDER BY
    1 ASC;

--문제3-1.
--문제3에서 부서가 없는 도시도 표시합니다.
--(43건)
SELECT
    l.location_id,
    l.city,
    d.department_name,
    d.department_id
FROM
    locations   l,
    departments d
WHERE
    l.location_id = d.location_id (+)
ORDER BY
    1 ASC;
---------------------------------------------
SELECT
    l.location_id     AS "도시아이디",
    l.city            AS "도시명",
    d.department_name AS "부서명",
    d.department_id   AS "부서아이디"
FROM
    locations   l
    LEFT OUTER JOIN departments d ON l.location_id = d.location_id
ORDER BY
    1 ASC;

--문제4.
--지역(regions)에 속한 나라들을 지역이름(region_name), 나라이름(country_name)으로 출력하
--되 지역이름(오름차순), 나라이름(내림차순) 으로 정렬하세요.
--(25건)
SELECT
    r.region_name  AS "지역이름",
    c.country_name AS "나라이름"
FROM
    regions   r,
    countries c
WHERE
    r.region_id = c.region_id
ORDER BY
    1 ASC,
    2 DESC;
----------------------------------------
SELECT
    r.region_name  AS "지역이름",
    c.country_name AS "나라이름"
FROM
    regions r
    JOIN countries c ON r.region_id = c.region_id
ORDER BY
    1 ASC,
    2 DESC;

--문제5.
--자신의 매니저보다 채용일(hire_date)이 빠른 사원의
--사번(employee_id), 이름(first_name)과 채용일(hire_date), 매니저이름(first_name), 매니저입
--사일(hire_date)을 조회하세요.
--(37건)
SELECT
    emp.employee_id 사번,
    emp.first_name  이름,
    emp.hire_date   채용일,
    man.first_name  매니저이름,
    man.hire_date   매니저입사일
FROM
    employees emp,
    employees man
WHERE
    emp.manager_id = man.employee_id

--자신의 매니저보다 채용일(hire_date)이 빠른 사원의
    AND emp.hire_date < man.hire_date;

--문제6.
--나라별로 어떠한 부서들이 위치하고 있는지 파악하려고 합니다.
--나라명, 나라아이디, 도시명, 도시아이디, 부서명, 부서아이디를 나라명(오름차순)로 정렬하여
--출력하세요.
--값이 없는 경우 표시하지 않습니다.
--(27건)
SELECT
    con.country_name    AS "나라명",
    con.country_id      AS "나라아이디",
    loc.city            AS "도시명",
    loc.location_id     AS "도시아이디",
    dep.department_name AS "부서명",
    dep.department_id   AS "부서아이디"
FROM
    countries   con,
    locations   loc,
    departments dep
WHERE
    con.country_id = loc.country_id
    AND loc.location_id = dep.location_id
ORDER BY
    1 ASC;

--문제7.
--job_history 테이블은 과거의 담당업무의 데이터를 가지고 있다.
--과거의 업무아이디(job_id)가 ‘AC_ACCOUNT’로 근무한 사원의 사번, 이름(풀네임), 업무아이
--디, 시작일, 종료일을 출력하세요.
--이름은 first_name과 last_name을 합쳐 출력합니다.
--(2건)
SELECT
    e.employee_id  AS "사번",
    e.first_name
    || ' '
    || e.last_name AS "이름",
    j.job_id       AS "업무아이디",
    j.start_date   AS "시작일",
    j.end_date     AS "종료일"
FROM
    employees   e,
    job_history j
WHERE
    e.employee_id = j.employee_id
    AND lower(
        j.job_id
    ) LIKE 'ac_account';

--------------------------------------------------------
SELECT
    e.employee_id  AS "사번",
    e.first_name
    || ' '
    || e.last_name AS "이름",
    j.job_id       AS "업무아이디",
    j.start_date   AS "시작일",
    j.end_date     AS "종료일"
FROM
    employees e
    JOIN job_history j ON e.employee_id = j.employee_id
                          AND lower(
        j.job_id
    ) LIKE 'ac_account';

--문제8.
--각 부서(department)에 대해서 부서번호(department_id), 부서이름(department_name),
--매니저(manager)의 이름(first_name), 위치(locations)한 도시(city), 나라(countries)의 이름
--(countries_name) 그리고 지역구분(regions)의 이름(resion_name)까지 전부 출력해 보세요.
--(11건)
SELECT
    d.department_id   AS "부서번호",
    d.department_name AS "부서이름",
    d.manager_id      AS "매니저번호",
    e.first_name      AS "매니저이름",
    l.city            AS "위치한도시",
    c.country_name    AS "나라",
    r.region_name     AS "지역"
FROM
    employees   e,
    departments d,
    locations   l,
    countries   c,
    regions     r
WHERE
    e.employee_id = d.manager_id
    AND d.location_id = l.location_id
    AND l.country_id = c.country_id
    AND c.region_id = r.region_id;

--------------------------------------------------------------
SELECT
    d.department_id   AS "부서번호",
    d.department_name AS "부서이름",
    d.manager_id      AS "매니저번호",
    e.first_name      AS "매니저이름",
    l.city            AS "위치한도시",
    c.country_name    AS "나라",
    r.region_name     AS "지역"
FROM
    employees e
    JOIN departments d ON e.employee_id = d.manager_id
    JOIN locations   l ON d.location_id = l.location_id
    JOIN countries   c ON l.country_id = c.country_id
    JOIN regions     r ON c.region_id = r.region_id
ORDER BY
    1;

--문제9.
--각 사원(employee)에 대해서 사번(employee_id), 이름(first_name), 부서명
--(department_name), 매니저(manager)의 이름(first_name)을 조회하세요.
--부서가 없는 직원(Kimberely)도 표시합니다.
--(106명)
SELECT
    e.employee_id,
    e.first_name,
    d.department_name,
    e.manager_id,
    man.first_name
FROM
    employees   e,
    departments d,
    employees   man
WHERE
    e.manager_id = man.employee_id
    AND e.department_id = d.department_id (+)
ORDER BY
    e.employee_id;
-------------------------------------------------------------------------
SELECT
    e.employee_id     AS "사번",
    e.first_name      AS "이름",
    d.department_name AS "부서명",
    e.manager_id      AS "매니저아이디",
    man.first_name    AS "매니저이름"
FROM
    employees e
    JOIN employees   man ON e.manager_id = man.employee_id
    LEFT OUTER JOIN departments d ON e.department_id = d.department_id
ORDER BY
    e.employee_id;
----------------------------------------------------------------------
--SELECT
--    emp.employee_id     사번,
--    emp.first_name      이름,
--    dep.department_name 부서명,
--    man.first_name      매니저이름
--FROM
--    employees   emp
--    JOIN employees man
--    ON emp.manager_id = man.employee_id
--    LEFT OUTER JOIN departments dep
--    ON emp.department_id = dep.department_id
--ORDER BY
--    1 ASC;
-----------------------------------------------------------------------