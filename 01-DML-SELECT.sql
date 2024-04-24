--  SQL 문장의 주석
--  SQL 문장은 마지막에 ;로 끝난다.
--  키워드들은 대소문자 구분하지 않는다.
--  실제  데이터의 경우 대소문자를 구분한다.

--  NUMBER(6) -> (총자리수, 소수점의자리수) -> 레코드 식별하는 PK "6자리 정수"
--  VARCHAR2(20) -> (가변문자 -> 길이가 가변적)
--  DATE -> (날짜,시간)
--  NOT NULL -> NULL 허용(x)
--  테이블의 구조를 확인 (DESCRIBE)
DESCRIBE employees;
Describe departments;
Describe Locations;

--  DML (Data manipulation Language)
--  SELECT

--  * : 테이블 내의 모든 컬럼 Projection, 테이블 설계시에 정의한 순서대로
SELECT * FROM employees;

--  특정 컬럼만 Projection 하고자 하면 열 목록을 명시

--  employees 테이블의 first_name, phone_number, hire_date, salary 만 보고 싶다면
SELECT first_name, phone_number, hire_date, salary From employees;

--  사원의 이름, 성, 급여, 전화번호, 입사일 정보를 출력
SELECT last_name, first_name, salary, phone_number, hire_date From employees;

--  사원 정보로부터 사번, 이릅, 성 정보 출력
SELECT employee_id, first_name, last_name From employees;

--  산술연산 : 기본적인 산술연산을 수행할 수 있다.
--  특정 테이블의 값이 아닌 시스템으로부터 데이터를 받아오고자 할때 : dual (가상테이블)
SELECT 3.14159 * 10 * 10 "산술" From dual;

--  특정 컬럼의 값을 산술 연산에 포함
SELECT first_name, salary, salary * 12 From employees;

SELECT first_name, job_id, job_id*12 From employees;
--  오류의 원인: JOB_ID   NOT NULL VARCHAR2(10)-> job_id는 문자열 (VARCHAR2)
DESC employees;
--SELECT salary + salary * NVL(commission_pct, 0) FROM employees;
-- NULL
-- 이름, 급여 출력
SELECT first_name, salary, commission_pct From employees;

-- 이름, 커미션까지 포함한 급여를 출력
-- as에는 띄어쓰기(X) ""사용하면 띄어쓰기 가능
-- SELECT first_name, salary + salary * NVL(commission_pct, 0) as 커미션 포합 월급 From employees;
SELECT first_name, salary, commission_pct, salary + salary * commission_pct as "커미션 포합 월급" From employees;
-- NULL이 포함된 연산식의 결과는 NULL
-- NULL을 처리하기 위한 함수 NVL이 필요
-- NVL(표현식1, 표현식1이 NULL일 경우의 대체값)
--SELECT first_name 성, salary 월급, commission_pct 커미션, salary + salary * NVL(commission_pct, 0) as 커미션포합월급 From employees;


-- NULL은 이나 "" 와 다르게 빈 값이다.
-- NULL은 산술연산 결과, 통계 결과를 왜곡 -> NULL에 대한 처리는 철저하게!

SELECT first_name ||' '|| last_name as "이름" FROM employees;
-- 별칭 Alias
-- Projection 단계에서 출력용으로 표시되는 임시 컬럼 제목

--  컬럼명 뒤에 별칭
--  컬럼명 뒤에 as 별칭
--  표시명에 특수문자 포함된 경우 ""로 묶어서 부여

--  직원 아이디, 이름, 급여
--  직원 아이디는 empNo, 이름은 f-name, 급여는 월 급으로 표시
SELECT employee_id as "empNO"
, first_name as "f-name"
, salary as "월 급"
FROM employees;

-- 직원 이름 (first_name last_name 합쳐서) name
-- 급여(커미션이 포함된 급여), 급여 * 12 연봉 별칭으로 표기
SELECT first_name ||' '|| last_name as "name"   --  문자열 합치기는 ||를 사용
, salary + salary * nvl(commission_pct, 0) as "급여(커미션포함)"
, salary * 12 as "연봉(커미션X)"
FROM employees;

--연습문제 (예제)
SELECT first_name ||' '|| last_name as "이름"
, hire_date as "입사일"
, phone_number as "전화번호"
, salary as "급여"
, salary * 12 as "연봉"
FROM employees;



----------------------
-- WHERE
-----------------
-- 특정 조건을 기준으로 레코드를 선택 (SELECTION)
-- 비교연산 : =, <>, >, >=, <, <=

-- 사원들 중 급여가 15000 이상인 직원의 이름과 급여
SELECT first_name, salary as "월급" FROM employees WHERE salary >= 15000;

-- 17/01/01일 이후 입사자들의 이름과 입사일을 출력하십시오.
SELECT first_name, hire_date FROM employees WHERE hire_date >= '17/01/01';
-- TO_DATE('20170101','YYYYMMDD') 형변환

-- 급여가 14000 이상이거나, 17000 이하인 사원의 이름과 급여
SELECT first_name, salary FROM employees WHERE salary >= 14000 AND salary <= 17000;

-- BETWEEN : 범위 비교
SELECT first_name, salary FROM employees WHERE salary between 14000 AND 17000;

-- NULL 체크 =, <> 사용하면 안됨
-- IS NULL, IS NOT NULL

-- commission을 받지 않는 사람들
SELECT first_name, commission_pct FROM employees WHERE commission_pct IS NULL;

-- commission을 받는 사람들
SELECT first_name, commission_pct FROM employees WHERE commission_pct IS NOT NULL;

-- IN 연산사: 특정 집합의 요소와 비교
-- 사원들 중에서 10, 20, 40번 부서에서 근무하는 직원들의 이름과 부서ID
SELECT first_name, department_id FROM employees WHERE department_id = 10 OR department_id = 20 OR department_id = 40;
-- IN 연산사 : 특정 집합의 요소와 비교
SELECT first_name, department_id FROM employees WHERE department_id IN (10, 20, 40);

-- 이름이 'Lex'인 사원의 연봉과 입사일, 부서 ID를 출력하십시오.
SELECT first_name, salary * 12, hire_date,  department_id FROM employees WHERE first_name IN 'Lex';

-- 부서 ID가 10인 사원의 명단이 필요합니다.
SELECT * FROM employees WHERE department_id = 10;

--------------------
-- LIKE 연산
----------------------
-- ,와일드카드(%,_)를 이용한 부분 문자열 매핑
-- % : 0개 이상의 정해지지 않은 문자열
-- _ : 1개의 정해지지 않은 문자

-- 이름에 am을 포함하고 있는 사원의 이름가 급여
SELECT first_name, salary FROM employees WHERE LOWER(first_name) LIKE '%am%';

-- 이름에 두 번째 글자가 a인 사원의 이름과 급여
SELECT first_name, salary FROM employees WHERE LOWER(first_name) LIKE '_a%';

-- 이름의 네번쨰 글자가 a인 사원의 이름과 급여
SELECT first_name, salary FROM employees WHERE LOWER(first_name) LIKE '___a%';

-- 이름이 네글자인 사원들 중에서 두번째 글자가 a인 사원 이름과 급여
SELECT first_name, salary FROM employees WHERE LOWER(first_name) LIKE '_a__';