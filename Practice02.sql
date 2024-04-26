--1
SELECT COUNT(manager_id) FROM employees;
--2
SELECT MAX(salary)as"최고임금", MIN(salary)as"최저임금",
MAX(salary)-MIN(salary)as"최고임금 - 최저임금"
FROM  employees;
--3
SELECT TO_CHAR(MAX(hire_date), 'YYYY"년" MM"월" DD"일"')
FROM employees;
--4
SELECT department_id, ROUND(AVG(salary),1),MAX(salary),MIN(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id DESC;
--5
SELECT ROUND(AVG(salary),1), MAX(salary), MIN(salary), job_id
FROM employees
GROUP BY job_id
ORDER BY MIN(salary)DESC, AVG(salary)ASC;
--6
SELECT TO_CHAR(MIN(hire_date),'YYYY-MM-DD DAY')
FROM employees
WHERE employee_id NOT IN(SELECT employee_id FROM job_history);
--7
SELECT nvl(department_id, 1),
    ROUND(AVG(salary),1) 평균임금,
    MIN(salary),
    ROUND(AVG(salary) - MIN(salary),1) "평균임금 - 최저임금"
FROM employees
GROUP BY department_id
HAVING AVG(salary) - MIN(salary) < 2000
ORDER BY AVG(salary) - MIN(salary) DESC;

--8
SELECT job_title, max_salary-min_salary
FROM jobs
ORDER BY 2 DESC;

--9

SELECT MIN(salary),
    MAX(salary),
    ROUND(AVG(salary),0),
    manager_id
FROM employees
WHERE manager_id IS NOT NULL
AND hire_date > TO_DATE('20150101'.'YYYYMMDD')
GROUP BY manager_id
HAVING AVG(salary) >= 5000
ORDER BY 3 DESC;
--10
SELECT employee_id, first_name, hire_date,
case WHEN hire_date < TO_DATE('20121231','YYYYMMDD') THEN '창립맴버'
    WHEN hire_date <  TO_DATE('20131231','YYYYMMDD') THEN '13년입사'
    WHEN hire_date <  TO_DATE('20141231','YYYYMMDD') THEN '14년입사'
ELSE '상장이후입사'
END as optDate
FROM employees
ORDER BY hire_date;