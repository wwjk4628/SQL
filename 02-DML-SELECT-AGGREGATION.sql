--------------
--  JOIN
--------------

-- employees와 departments
DESC employees;
DESC departments;

SELECT * FROM employees;    --  107
SELECT * FROM departments;  --  27

SELECT * 
FROM employees, departments;
-- 카티젼 프로덕트

SELECT * 
FROM employees, departments
WHERE employees.department_id = departments.department_id;  --  106
--  INNER JOIN, EQUI-JOIN

-- alias를 이용한 원하는 필드의 projection
-- Simple Join or Equi-Join
SELECT first_name, emp.department_id, dept.department_id, department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id;
-- employees에 있는 department_id가 NULL을 제외

SELECT * FROM employees
WHERE department_id IS NULL;

SELECT emp.first_name,
    dept.department_name
FROM employees emp JOIN departments dept USING(department_id);


----------------
-- Theta Join
----------------

-- Join 조건이 = 아닌 다른 조건을 

-- 급여가 직군 평균 급여보다 낮은 직원들 목록
SELECT emp.employee_id,
    emp.first_name,
    emp.salary,
    emp.job_id,
    j.job_id,
    j.job_title
FROM employees emp join jobs j ON emp.job_id = j.job_id
WHERE emp.salary <= (j.min_salary + j.max_salary)/2;

-------------------
--  OUTER JOIN
-------------------
-- 조건을 만족하는 짝이 없는 튜플도 NULL을 포함해서 결과 출력에 참여시킨 방법
-- 모든 결과를 포현할 테이블이 어느쪽에 위치하는 가 LEFT, RIHGT, FULL OUTER JOIN 으로 구분
-- ORACLE SQL의 경우 NULL이 출력되는 쪽에 (+)를 붙인다.

-----------------
--LEFT OUTER JOIN
-----------------
-- ORACLE SQL
SELECT e.first_name,
    e.department_id,
    d.department_id,
    d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id (+);    -- null이 포함된 테이블 쪽에 (+) 표기

SELECT *
FROM employees
WHERE department_id IS NULL;    --  Kimberely -> 부서에 소속 x

--  ANSI SQL 명시적으로 JOIN 방법을 정한다.
SELECT first_name,
    e.department_id,
    d.department_id,
    d.department_name
FROM employees e LEFT OUTER JOIN departments d
    ON e.department_id = d.department_id; 

-------------------
-- RIGHT OUTER JOIN
-------------------
-- RIGHT 테이블의 모든 레코드가 출력 결과에 참여

-- Oracle SQL
SELECT e.first_name,
    e.department_id,
    d.department_id,
    d.department_name
FROM employees e, departments d
WHERE e.department_id (+) = d.department_id;

SELECT e.first_name,
    e.department_id,
    d.department_id,
    d.department_name
FROM employees e RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id;

----------------------------
-- FULL OUTER JOIN
-------------------------

-- JOIN에 참여한 모든 테이블의 모든 레코드를 출력에 참여
-- 짝이 없는 레코드들은 null을 포함해서 출력에 참여

-- ANSI SQL

SELECT e.first_name,
    e.department_id,
    d.department_id,
    d.department_name
FROM employees e FULL OUTER JOIN departments d
ON e.department_id = d.department_id
ORDER BY 3;

--------------------
-- NATURAL JOIN
--------------------

-- JOIN할 테이블에 같은 이름의 컬럼이 있을 경우, 해당 컬럼을 기준으로 JOIN
SELECT *
FROM employees e NATURAL JOIN departments d;

SELECT * 
FROM employees e JOIN departments d ON e.department_id = d.department_id;

SELECT * 
FROM employees e JOIN departments d ON e.manager_id = d.manager_id AND e.department_id = d.department_id;

------------------
-- SELF JOIN
-------------------

SELECT e1.employee_id,
    e1.first_name,
    e1.manager_id,
    e2.first_name
FROM employees e1 JOIN employees e2
    ON  e1.manager_id = e2.employee_id;
    
SELECT e1.employee_id,
    e1.first_name,
    e1.manager_id,
    e2.first_name
FROM employees e1, employees e2
WHERE e1.manager_id = e2.employee_id;

-- Steven 포함해서 출력
SELECT e1.employee_id,
    e1.first_name,
    e1.manager_id,
    e2.first_name
FROM employees e1 LEFT OUTER JOIN employees e2
    ON  e1.manager_id = e2.employee_id;
    
---------------------------------------
--  GROUP Aggregation
---------------------------------------

-- 집계 : 여러 행으로부터 데이터를 수집, 하나의 행으로 반환

-- COUNT : 갯수 세기 함수
-- employees 테이블의 총 레코드 갯수?
SELECT COUNT(*) FROM employees;

-- *로 카운트 하면 모든 행의 수를 반환
-- 특정 컬럼 내에 NULL 값이 포함되어 있는지의 여부는 중요하지 않음

-- commission을 받는 직원의 수를 알고 싶을 경우
SELECT COUNT (commission_pct) FROM employees;

SELECT COUNT(*) 
FROM employees
WHERE commission_pct IS NOT NULL;

-- SUM : 합계 함수 
-- 모든 사원의 급여의 합계
SELECT SUM(salary) FROM employees;

-- AVG : 평균 함수
-- 사원들의 평균 급여?
SELECT AVG(salary) FROM employees;

-- 사원들이 받는 커미션 비율의 평균
SELECT AVG(commission_pct) FROM employees;  --  22%
-- AVG 함수는 NULL 값이 포함되어 있는 경우 그 값을 집계 수치에서 제외
-- NULL 값을 집계 결과에 포함시킬지의 여부는 정책으로 결정하고 수행해야 한다.
SELECT AVG(nvl(commission_pct, 0)) FROM employees;

-- MIN/MAX : 최솟값/최댓값
-- AVG/MEDIAN : 산술평균/중앙값
SELECT MIN(salary) 최소급여,
    MAX(salary) 최대급여,
    AVG(salary) 평균급여,
    MEDIAN(salary) 급여중앙값
FROM employees;

-- 흔히 범하는 오류
-- 부서별로 평균 급여를 구하고자 할 때
SELECT department_id, AVG(salary)
FROM employees;

SELECT department_id FROM employees;    --  여러 개의 레코드
SELECT AVG(salary) FROM employees;  --  단일 레코드

SELECT department_id, salary
FROM employees
ORDER BY department_id;
-------------------------------------------------------------
-- GROUP BY
SELECT department_id, ROUND(AVG(salary),2)
FROM employees
--WHERE department_id IS NOT NULL
GROUP BY department_id  --  집계를 위해 특정 컬럼을 기준으로 그룹핑
ORDER BY department_id;
