-------------------------
--  DCL and DDL
-------------------------
--  사용자 생성
--  CREATE USER 권한이 있어야 함
--  system 계정으로 수행
--connect system/manager

-- himedia라는 이름의 계정을 만들고 비밀번호 himedia로 설정
CREATE USER himedia IDENTIFIED BY himedia;

-- Oracle 18버준부터 Container Database 개념 도입
-- 계정 생성 방법1. 사용자 계정 C##
CREATE USER C##HIMEDIA IDENTIFIED BY himedia;

-- 비밀번호 변경 : ALTER USER
ALTER USER C##HIMEDIA IDENTIFIED BY new_password;

-- 계정 삭제 : DROP USER
DROP USER C##HIMEDiA CASCADE;   -- CASCADE : 폭포수 or 연결된 것 의미

-- 계정 생성 방법 2. CD 기능 무력화
-- 연습 상태, 방법 2를 사용해서 사용자 생성 (추천 X)
ALTER SESSION SET "_ORACLE_SCRIPT" = true;
CREATE USER himedia IDENtIFIED BY himedia;

-- 아직 접속 불가
-- 데이터베이스 접속, 테이블 생성 데이터베이스 객체 작업을 수행 -> CONNECT, RESOURCE ROLE
GRANT CONNECT, RESOURCE TO himedia;
-- cmd : sqlplus himedia/himedia
-- CREATE TABLE test(a NUMBER);
-- DESC test;  -- 구조보기

-- himedia 사용자로 진행
-- 데이터 추가
DESCRIBE test;
INSERT INTO test VALUES (2024);     --  실행불가
-- USERS 테이블스페이스에 대한 접근 권한이 없다.
-- Oracle 18이상
-- SYSTEM 계정으로 수행
ALTER USER himedia DEFAULT TABLESPACE USERS
    QUOTA unlimited on USERS;

-- himedia 사용자로 진행
INSERT INTO test VALUES (2024);
SELECT * FROM test;

SELECT * FROM USER_USERS;   --  현재 로그인한 사용자 정보 (나)
SELECT * FROM ALL_USERS;    --  모든 사용자 정보
--  DBA 전용 (sysdba로 로그인 해야 확인 가능)
--  cmd : sqlplus sys/oracle as sysdba -> sysdba로 접속 가능
SELECT * FROM DBA_USERS;

--  시나리오 : HR 스키마의 employees 테이블 조회 권한을 himedia에게 부여하고자 한다.
--  HR 스키마의 Owner -> HR
--  HR로 접속
GRANT SELECT ON employees TO himedia;

-- himedia 권한
SELECT * FROM hr.employees; --  hr.employees에 SELECT 할 수 있는 권한
SELECT * FROM hr.departments;   --hr.departments에 대한 권한은 없다.

---------------------
--  DDL
---------------------

-- 스키마 내의 모든 테이블을 확인
SELECT * FROM tabs; --  tabs : 테이블 정보 DICTIONARY
-- 테이블 생성
CREATE TABLE book (
    book_id NUMBER(5),
    title VARCHAR2(50),
    author VARCHAR2(10),
    pub_date DATE DEFAULT SYSDATE
    );
    
--   테이블 정보 확인
DESC book;

--  subquery를 이용한 테이블 생성
SELECT * FROM hr.employees;

-- HR.employees 테이블에서 job_id가 IT 관련된 직원들의 목록으로 새테이블을 생성
SELECT * FROM hr.employees WHERE job_id LIKE 'IT%';

CREATE TABLE emp_it AS (
    SELECT * FROM hr.employees WHERE job_id LIKE 'IT%'
    );
--  NOT NULL 제약 조건만 물려받음
SELECT * FROM tabs;
DESC emp_it;
SELECT * FROM emp_it;

-- 테이블 삭제
DROP TABLE emp_it;

SELECT * FROM tabs;

DESC book;

--  현재 사용자에게 부여된 ROLE의 확인
SELECT * FROM user_role_privs;

-- CONNECT와 RESOURCE 역할은 어떤 권한으로 구성되어 있는가?
-- sysdba로 진행
-- cmd
-- sqlplus sys/oracle as sysdba
-- DESC role_sys_privs;
-- CONNECT ROLE에는 어떤 권한이 포함되어 있는가?
-- SELECT privilege FROM role_sys_privs WHERE role='CONNECT';
-- RESOURCE ROLE 에는 어떤 권한이 포함되어 있는가?
-- SELECT privilege FROM role_sys_privs WHERE role='RESOURCE';

-- 조회
DESC book;

-- author 테이블 생성
CREATE TABLE author (
    author_id NUMBER(10) ,       --  pk author_id NUMBER(10) primary key로 바로 조건 가능
    author_name VARCHAR2(100) NOT NULL,  
    author_desc VARCHAR2(500),
    PRIMARY KEY (author_id) --  PRIMARY KEY (컬럼이름)
    );
    
-- 조회
DESC author;

-- book테이블의 author컬럼 삭제
-- 나중에 author_id 컬럼 추가 -> author.author_id 참조 연결할 예정
ALTER TABLE book DROP COLUMN author;
DESC book;

-- book 테이블에 author_id 컬럼 추가
-- author.author_id를 참조하는 컬럼 author.author_id 컬럼과 같은 형태여야 한다.
ALTER TABLE book ADD (author_id NUMBER(10));
DESC book;

-- book 테이블의 book_id도 author 테이블의 PK와 같은 데이터타입 (NUMBER(10))으로 변경
ALTER TABLE book MODIFY (book_id NUMBER(10));
DESC book;

-- book 테이블의 book_id 컬럼에 PRIMARY KEY 제약조건을 부여
ALTER TABLE book
ADD CONSTRAINT pk_book_id PRIMARY KEY (book_id);
DESC book;

-- book테이블의 author_id 컬럼과 author테이블의 author_id를 FK로 연결
ALTER TABLE book
ADD CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES author(author_id);
DESC book;

-- DICTIONARY
-- USER_ : 현재 로그인된 사용자에게 허용된 뷰
-- ALL_ : 모든 사용자 뷰
-- DBA_ : DBA에게 허용된 뷰

-- 모든 딕셔너리 확인
SELECT * FROM DICTIONARY;

-- 사용자 스키마 객체 : USER_OBJECTS
SELECT * FROM USER_OBJECTS;

-- 제약 조건 확인
SELECT * FROM USER_CONSTRAINTS;
SELECT CONSTRAINT_NAME,
    CONSTRAINT_TYPE,
    SEARCH_CONDITION,
    TABLE_NAME
FROM USER_CONSTRAINTS;
-- BOOK 테이블에 적용된 제약조건의 확인
SELECT CONSTRAINT_NAME,
    CONSTRAINT_TYPE,
    SEARCH_CONDITION,
    TABLE_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'BOOK';

TRUNCATE TABLE author;

-- INSERT : 테이블에 새 레코드(튜플) 추가
-- 제공된 컬럼 목록의 순서와 타입, 값 목록의 순서와 타입이 일치해야 함
-- 컬럼 목록을 제공하지 않으면 테이블 생성시 정의된 컬럼의 순서와 타입을 따른다.

-- 컬럼 목록이 제시되지 않았을 떄
INSERT INTO author
VALUES (1, '박경리', '토지 작가');

SELECT * FROM author;

-- 컬럼 목록을 제시했을 때,
-- 제시한 컬럼의 순서와 타입대로 값 목록을 제공해야함
INSERT INTO author (author_id, author_name)
VALUES (2, '김영하');

SELECT * FROM author;

INSERT INTO author (author_name, author_id, author_desc)
VALUES ('류츠신', 3, '삼체 작가');

SELECT * FROM author;

-- ROLLBACK (되돌리기?): 반영 취소
ROLLBACK;
SELECT * FROM author;

INSERT INTO author
VALUES (1, '박경리', '토지 작가');

SELECT * FROM author;

INSERT INTO author (author_id, author_name)
VALUES (2, '김영하');

SELECT * FROM author;

INSERT INTO author (author_name, author_id, author_desc)
VALUES ('류츠신', 3, '삼체 작가');

SELECT * FROM author;

COMMIT; -- 변경사항 반영
SELECT * FROM author;

-- UPDATE
-- 특정 레코드의 컬럼 값을 변경한다
-- WHERE 절이 없으면 모든 레코드가 변경
-- 가급적 WHERE 절로 변경하고자 하는 레코드를 지정하도록 함
UPDATE author
SET author_desc = '알쓸신잡 출연';
SELECT * FROM author;

ROLLBACK;
SELECT * FROM author;

UPDATE author
SET author_desc = '알쓸신잡 출연' WHERE author_name = '김영하';
SELECT * FROM author;

COMMIT;

-- DELETE 
-- 테이블로부터 특정 레코드를 삭제
-- WHERE 절이 없으면 모든 레코드를 삭제 (주의)

-- 연습
-- hr.employees 테이블을 기반으로 department_id 10, 20, 30인 직원들만 새테이블 emp123으로 생성

CREATE TABLE emp123 AS
    (SELECT * FROM hr.employees WHERE department_id IN (10, 20, 30));
    
SELECT * FROM emp123;

-- 부서가 30인 직원들의 급여를 10%인상
UPDATE emp123
SET salary = salary + salary * 0.1
WHERE department_id = 30;

SELECT * FROM emp123;

-- JOB_ID MK_로 시작하는 직원들 삭제
DELETE FROM emp123
WHERE job_id LIKE 'MK_%';

SELECT * FROM emp123;

DELETE FROM emp123; --  WHERE 절이 생략된 DELETE 문은 모든 레코드를 삭제 -> 주의
SELECT * FROM emp123;

ROLLBACK;


-- 트랜잭션 테스트 테이블
CREATE TABLE t_test(
    log_text VARCHAR2(100)
);

-- 첫 번쨰 DML이 수행된 시점에서 Transaction
INSERT INTO t_test VALUES ('트랜잭션 시작');
SELECT * FROM t_test;
INSERT INTO t_test VALUES ('데이터 INSERT');
SELECT * FROM t_test;

SAVEPOINT spl;

INSERT INTO t_test VALUES ('데이터2 INSERT');

SELECT * FROM t_test;

SAVEPOINT sp2;

UPDATE t_test set log_text = '업데이트';

SELECT * FROM t_test;

ROLLBACK TO sp2;

SELECT * FROM t_test;

ROLLBACK TO spl;

SELECT * FROM t_test;

INSERT INTO t_test VALUES('데이터 3 INSERT');

SELECT * FROM t_test;

-- 반영 : COMMIT or 취소: ROLLBACK

COMMIT;
SELECT * FROM t_test;