--  SQL 문장의 주석
--  SQL 문장은 마지막에 ;로 끝난다.
--  키워드들은 대소문자 구분하지 않는다.
--  실제 데이터의 경우 대소문자를 구분한다.

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
SELECT 3.14159 * 10 * 10 From dual;

--  특정 컬럼의 값을 산술 연산에 포함
SELECT first_name, salary, salary * 12 From employees;

SELECT first_name, job_id, job_id*12 From employees;
--  오류의 원인: JOB_ID   NOT NULL VARCHAR2(10)-> job_id는 문자열 (VARCHAR2)
DESC employees;