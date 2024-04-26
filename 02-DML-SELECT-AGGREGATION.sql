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