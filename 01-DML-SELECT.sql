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
SELECT first_name
, salary
, salary * 12 
From employees;

SELECT first_name
, job_id, job_id*12
From employees;
--  오류의 원인: JOB_ID   NOT NULL VARCHAR2(10)-> job_id는 문자열 (VARCHAR2)
DESC employees;
--SELECT salary + salary * NVL(commission_pct, 0) FROM employees;
-- NULL
-- 이름, 급여 출력
SELECT first_name
, salary
, commission_pct 
From employees;

-- 이름, 커미션까지 포함한 급여를 출력
-- as에는 띄어쓰기(X) ""사용하면 띄어쓰기 가능
-- SELECT first_name, salary + salary * NVL(commission_pct, 0) as 커미션 포합 월급 From employees;
SELECT first_name, salary
, commission_pct
, salary + salary * commission_pct as "커미션 포합 월급" 
From employees;
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
SELECT first_name, salary as "월급" 
FROM employees WHERE salary >= 15000;

-- 17/01/01일 이후 입사자들의 이름과 입사일을 출력하십시오.
SELECT first_name, hire_date 
FROM employees WHERE hire_date >= '17/01/01';
-- TO_DATE('20170101','YYYYMMDD') 형변환

-- 급여가 14000 이상이거나, 17000 이하인 사원의 이름과 급여
SELECT first_name, salary 
FROM employees WHERE salary >= 14000 AND salary <= 17000;

-- BETWEEN : 범위 비교
SELECT first_name, salary 
FROM employees WHERE salary between 14000 AND 17000;

-- NULL 체크 =, <> 사용하면 안됨
-- IS NULL, IS NOT NULL

-- commission을 받지 않는 사람들
SELECT first_name, commission_pct 
FROM employees WHERE commission_pct IS NULL;

-- commission을 받는 사람들
SELECT first_name, commission_pct 
FROM employees WHERE commission_pct IS NOT NULL;

-- IN 연산사: 특정 집합의 요소와 비교
-- 사원들 중에서 10, 20, 40번 부서에서 근무하는 직원들의 이름과 부서ID
SELECT first_name, department_id 
FROM employees WHERE department_id = 10 OR department_id = 20 OR department_id = 40;
-- IN 연산사 : 특정 집합의 요소와 비교
SELECT first_name, department_id 
FROM employees WHERE department_id IN (10, 20, 40);

-- 이름이 'Lex'인 사원의 연봉과 입사일, 부서 ID를 출력하십시오.
SELECT first_name, salary * 12, hire_date,  department_id 
FROM employees WHERE first_name IN 'Lex';

-- 부서 ID가 10인 사원의 명단이 필요합니다.
SELECT * FROM employees WHERE department_id = 10;

--------------------
-- LIKE 연산
----------------------
-- ,와일드카드(%,_)를 이용한 부분 문자열 매핑
-- % : 0개 이상의 정해지지 않은 문자열
-- _ : 1개의 정해지지 않은 문자

-- 이름에 am을 포함하고 있는 사원의 이름가 급여
SELECT first_name, salary 
FROM employees WHERE LOWER(first_name) LIKE '%am%';

-- 이름에 두 번째 글자가 a인 사원의 이름과 급여
SELECT first_name, salary 
FROM employees WHERE LOWER(first_name) LIKE '_a%';

-- 이름의 네번쨰 글자가 a인 사원의 이름과 급여
SELECT first_name, salary 
FROM employees WHERE LOWER(first_name) LIKE '___a%';

-- 이름이 네글자인 사원들 중에서 두번째 글자가 a인 사원 이름과 급여
SELECT first_name, salary 
FROM employees WHERE LOWER(first_name) LIKE '_a__';

-- 부서 ID가 90인 사원중, 급여가 20000 이상인 사원은 누구입니까?
SELECT first_name, department_id, salary 
FROM employees WHERE department_id = 90 AND salary > 20000;

-- 입사일이 11/01/01 ~ 17/12/31 구간에 있는 사원의 목록
SELECT first_name, hire_date 
FROM employees WHERE hire_date between '11/01/01' AND '17/12/31';

-- manager_id 가 100, 120, 147인 사원의 명단
-- 1. 비교연산자+논리연산자의 조합
SELECT first_name, manager_id
FROM employees 
WHERE manager_id = 100
OR manager_id = 120
OR manager_id = 147;
-- 2. IN 연산자 이용
SELECT first_name, manager_id 
FROM employees
WHERE manager_id IN (100, 120, 147);

--  부서 번호를 오름차순으로 정렬하고 부서번호, 급여 이름을 출력하십시오
SELECT department_id,
    salary,
    first_name
    FROM employees
    ORDER BY department_id ASC;
    
--  급여가 10000이상인 직원의 이름을 급여 내림차순(높은 급여 -> 낮은 급여)으로 출력하십시오.
SELECT first_name,
    salary
    FROM employees
    WHERE salary >= 10000
    ORDER BY salary DESC;
    
--  부서 번호, 급여, 이름 순으로 출력하되 부서번호 오름차순, 급여 내림차순으로 출력하십시오.    
SELECT department_id,
    salary,
    first_name
    FROM employees
    ORDER BY department_id ASC, salary DESC;
--  정렬 기준을 어떻게 세우느냐에 따라 성능, 출력 결과 영향을 미칠 수 있다.


---------------------------
-- 단일행 함수
----------------------
-- 단일 레코드를 기준으로 특정 컬럼의 값에 적용되는 함수

-- 문자열 단일행 함수
SELECT first_name, last_name,
    CONCAT(first_name, CONCAT(' ', last_name)),
    first_name || ' ' || last_name,
    INITCAP(first_name || ' ' || last_name)
FROM employees;

SELECT first_name, last_name,
LOWER(first_name),
UPPER(first_name),
LPAD(first_name, 20, '*'),
RPAD(first_name, 20, '*')
FROM employees;

SELECT '    Oracle  ',
    '*****Database*****',
    LTRIM('    Oracle  '), -- 왼쪽의 빈 공간 삭제
    RTRIM('    Oracle  '),   -- 오른쪽의 빈 공간 삭제
    TRIM('*' FROM '*****Database*****'),    -- 앞뒤의 잡음 문자 제거
    LTRIM('*****Database*****','*'), --  왼쪽의 '*' 문자 제거
    SUBSTR('Oracle Database', 8, 4),
    SUBSTR('Oracle Database', -8, 4),
    LENGTH('Oracle Database')   -- 문자열의 길이
FROM dual;

-- 수치형 단일행 함수

SELECT 3.14159,
ABS(-3.14), --  절대값
CEIL(3.14), --  정수로 올림
FLOOR(3.14),    -- 정수로 버림
ROUND(3.5), -- 정수로 반올림
ROUND(3.14159,3),    -- 소수점 3쨰 자리까지 반올림 (네쨰 자리에서 반올림)
TRUNC(3.5),     --  버림
TRUNC(3.14159,3),  --  소수점 네쨰 자리에서 버림
SIGN(-3.14159),  --  부호 (-1: 음수, 0:0, 1: 양수)
MOD(7,3),    --  7을 3으로 나눈 나머지
POWER(2,4)  --  2의 4제곱
FROM dual;

--------------
-- DATA FORMAT
--------------
-- 현재 세션 정보 확인
SELECT * FROM nls_session_parameters;
-- 현재 날짜 포맷이 어떻게 되는가?
-- 딕셔너리를 확인
SELECT value FROM nls_session_parameters
WHERE parameter = 'NLS_DATE_FORMAT';
-- session -> 현재 접속된 사용자의 환경정보

-- 현재 날자 : SYSDATE
SELECT sysdate FROM dual;   --  가상테이블 dual로 부터 받아오므로 1개의 레코드

SELECT sysdate FROM employees;  --  employees 테이블로부터 받아오므로 employees테이블 레코드의 갯수만큼

--  날자 관련 단일행 함수
SELECT sysdate,
ADD_MONTHS(sysdate, 2),  -- 2개월이 지난 후의 날자
LAST_DAY(sysdate),   --  현재달의 마지막 날
ROUND(MONTHs_BETWEEN(sysdate, LAST_DAY(sysdate))),
ROUND(MONTHs_BETWEEN('12/09/24', sysdate)), --  두 날자 사이의 개월 차
NEXT_DAY(sysdate,6), -- 일:1 ~ 토:7   다음 금요일
ROUND(sysdate, 'MONTH'),
TRUNC(sysdate, 'MONTH')
FROM dual;

SELECT first_name, hire_date,
ROUND(MONTHS_BETWEEN(sysdate, hire_date),1) as "근속월수"
FROM employees;

---------------
--  변환함수
---------------

-- TO_NUMBEr(s, fmt) : 문자열 -> 숫자
-- TO_DATE(s, fmt) : 문자열 -> 날짜
-- TO_CHAR(o, fmt) : 숫자, 날짜 -> 문자열

-- TO_CHAR
SELECT first_name, hire_date,
TO_CHAR(hire_date, 'yyyy-MM-DD')
FROM employees;

-- 현재 시간을 년-월-일 시:분:초:로 표기
SELECT sysdate,
TO_CHAR(sysdate, 'YYYY-MM-DD AM HH:MI:SS')
FROM dual;

SELECT 
TO_CHAR(3000000, 'L999,999,999,999.99')
FROM dual;

-- 모든 직원의 이름과 연봉 정보를 표시
SELECT first_name, salary, commission_pct,
TO_CHAR((salary + salary * nvl(commission_pct, 0))*12, '$999,999,999.99')
FROM employees;

-- 문자를 숫자로: TO_NUMBER\
SELECT '$57,600',
TO_NUMBER('$57,600.00', '$999,999.00')/12 월급
FROM dual;

-- 문자열 -> 날짜
SELECT '2024년04월25일 13시48분00초',
TO_DATE('2024년04월25일 13시48분00초', 'YYYY"년"MM"월"DD"일" HH24"시"MI"분"SS"초"')
FROM dual;

SELECT '2024-04-25 13:48:00',
TO_DATE('2024-04-25 13:48:00', 'YYYY-MM-DD HH24:MI:SS')
FROM dual;

-- 날짜 연산
-- Date +/- Number : 특정 날수를 더하거나 뺄 수 있다.
-- Date - Date : 두 날짜의 경과 일수
-- Date + Number / 24 : 특정 시간이 지난 후의 날짜
SELECT sysdate,
sysdate + 1, sysdate - 1,
ROUND(sysdate - TO_DATE('20120924'),1) as "경과 일수",
sysdate + 48 / 24 as "n시간 후"
FROM dual;

-- nvl function
SELECT first_name, salary, salary * nvl(commission_pct, 0) commission
FROM employees;

-- nvl2 function
SELECT first_name, salary,
nvl2(commission_pct, salary * commission_pct, salary * 0)
FROM employees;

-- CASE function
-- 보너스를 지급하기로 했습니다.
-- AD관련 직종에게는 20%, SA관련 직원에게는 10%, IT관련 직우너들에게는 8%, 나머지에게는 5%
SELECT first_name, job_id, salary,
SUBSTR(job_id, 1, 2),
CASE SUBSTR (job_id, 1, 2) WHEN 'AD' THEN salary * 0.2
WHEN 'SA' THEN salary * 0.1
WHEN 'IT' THEN salary * 0.08
ELSE salary * 0.05 
END as "보너스"
FROM employees;

-- DECODE 함수
SELECT first_name, job_id, salary,
SUBSTR(job_id, 1, 2),
DECODE(SUBSTR(job_id, 1, 2), 'AD', salary * 0.2,
'SA', salary * 0.1,
'IT', salary * 0.08,
salary * 0.05)보너스
FROM employees;

-- 연습문제
-- 직원의 이름, 부서, 팀을 출력
-- 팀은 부서 ID로 결정
-- 10 ~ 30 : A-GROUP
-- 40 ~ 50 : B-GROUP
-- 60 ~ 100 : C-GROUP
-- 나머지 부서 : REMAINDER
SELECT first_name, department_id,
CASE WHEN department_id <= 30 THEN 'A-GROUP'
     WHEN department_id <= 50 THEN 'B-GROUP'
     WHEN department_id <= 100 THEN 'C-GROUP'
ELSE 'REMAINDER'
END team
FROM employees
ORDER BY TEAM ASC, department_id ASC;

--SELECT first_name, department_id,
--DECODE (TRUE,
--department_id <= 30, 'A-GROUP',
--department_id <= 50, 'B-GROUP',
--department_id <= 100,'C-GROUP',
--'REMAINDER') as "TEAM"
--FROM employees
--ORDER BY department_id ASC;
SELECT 
    first_name,
    department_id,
    DECODE (
        SIGN(department_id - 31),  -- A-GROUP
        -1, 'A-GROUP',
        DECODE (
            SIGN(department_id - 51),  -- B-GROUP
            -1, 'B-GROUP',
            DECODE (
                SIGN(department_id - 101),  -- C-GROUP
                -1, 'C-GROUP',
                'REMAINDER'  -- REMAINDER
            )
        )
    ) AS "TEAM"
FROM employees
ORDER BY department_id ASC;