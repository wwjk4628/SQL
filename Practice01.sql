--  문제1
SELECT manager_id,  first_name ||' '|| last_name ,
salary ,
phone_number ,
hire_date 
FROM employees
ORDER BY nvl(manager_id,0) ASC, hire_date ASC;

--  문제1
SELECT first_name ||' '|| last_name as "이름",
salary as "월급",
phone_number as "전화번호",
hire_date as "입사일"
FROM employees
ORDER BY hire_date ASC;

-- 문제2
SELECT job_title, max_salary
FROM jobs
ORDER BY max_salary DESC;

-- 문제3
SELECT first_name ||' '|| last_name, manager_id, commission_pct, salary
FROM employees
WHERE manager_id IS NOT NULL AND commission_pct IS NULL AND salary > 3000;

-- 문제4
SELECT job_title, max_salary
FROM jobs
WHERE max_salary >= 1000
ORDER BY max_salary DESC;

-- 문제5
SELECT first_name, salary, nvl(commission_pct, 0)
FROM employees
WHERE salary BETWEEN 10000 AND 13999
ORDER BY salary DESC;

-- 문제6
SELECT first_name, salary, TO_CHAR(hire_date,'YYYY-MM'), department_id
FROM employees
WHERE department_id IN (10, 90, 100);

-- 문제 7
SELECT first_name, salary
FROM employees
WHERE LOWER(first_name) LIKE '%s%';

-- 문제8
SELECT department_name
FROM departments
ORDER BY LENGTH(department_name) DESC, department_name ASC;

-- 문제9
SELECT UPPER(country_name)
FROM countries
WHERE country_id IN(SELECT country_id FROM locations)
ORDER BY UPPER(country_name) ASC;

-- 문제10
SELECT first_name, salary, SUBSTR (TRANSLATE(phone_number,'.','-'),3) as "전화번호" , hire_date
FROM employees
WHERE hire_date < TO_DATE('20131231','YYYYMMDD');