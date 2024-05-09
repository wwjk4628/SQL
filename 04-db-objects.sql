-- DB OBJECTS

-- SYSTEM ---------------------------------------------------------
-- VIEW 생성 권한 주기
GRANT CREATE VIEW TO himedia;

GRANT SELECT ON hr.employees TO himedia;

GRANT SELECT ON hr.departments TO himedia;

-- HIMEDIA ---------------------------------------------------------


-- SIMPLE VIEW
-- hr.employees를 복사해온 테이블 emp123
desc emp123;

SELECT *
FROM emp123;

-- dep_id 10인 직원 view
CREATE VIEW emp10 AS
    SELECT *
    FROM emp123
    WHERE department_id = 10;

SELECT *
FROM emp10;

-- 급여 2배로 갱신
UPDATE emp10
SET
    salary = salary * 2;

-- 되돌려놓자
ROLLBACK;

-- DML의 SELECT를 제외한 명령은 안전상 못쓰도록 하자
CREATE OR REPLACE VIEW emp10 AS
    SELECT *
    FROM emp123
    WHERE department_id = 10 WITH READ ONLY;

-- 다시 급여 2배로? 불가능할 것
UPDATE emp10
SET
    salary = salary * 2;

-- HIMEDIA ---------------------------------------------------------
-- COMPLEX VIEW
CREATE VIEW emp_detail (
    employee_id,
    employee_name,
    manager_name,
    department_name
) AS
    SELECT emp.employee_id,
        emp.first_name
        || ' '
        || emp.last_name,
        man.first_name
        || ' '
        || man.last_name,
        dep.department_name
    FROM hr.employees   emp
        JOIN hr.employees man
        ON emp.manager_id = man.employee_id
        JOIN hr.departments dep
        ON emp.department_id = dep.department_id WITH READ ONLY;

-- 조회
SELECT *
FROM emp_detail;

desc emp_detail;

SELECT *
FROM user_views;

SELECT *
FROM user_objects;

-- VIEW 삭제
DROP VIEW emp_detail;

-- HIMEDIA ---------------------------------------------------------
-- INDEX

-- 먼저 테이블 복사
CREATE TABLE s_emp AS
    SELECT *
    FROM hr.employees;

desc s_emp;

SELECT *
FROM s_emp;

-- s_emp테이블의 사번에 INDEX
CREATE UNIQUE INDEX s_emp_id_pk
ON s_emp (employee_id);

-- 조회
SELECT *
FROM user_indexes;

SELECT *
FROM user_ind_columns;

SELECT t.index_name,
    t.table_name,
    c.column_name,
    c.column_position
FROM user_indexes     t
    JOIN user_ind_columns c
    ON t.index_name = c.index_name;

SELECT object_name,
    created,
    status
FROM user_objects
WHERE object_type='INDEX';

-- HIMEDIA ---------------------------------------------------------
-- SEQUENCE

desc author;

SELECT *
FROM author;

-- 이렇게 만들면 동시성 문제가 생길 수 있다.
INSERT INTO author (
    author_id,
    author_name
) VALUES (
    (SELECT MAX(author_id) + 1 FROM author),
    '이문열'
);

ROLLBACK;

-- SEQUENCE부터 만들자.
CREATE SEQUENCE seq_author_id
    START WITH 3
    MAXVALUE 100000;

-- 혹시 시퀀스를 다시 만들려면 삭제
DROP SEQUENCE seq_author_id;

-- 시퀀스를 수정하려면 ALTER
ALTER SEQUENCE seq_author_id
    INCREMENT BY 1
--    START WITH 1  시작번호는 바꿀 수 없다.
    MAXVALUE 100000;
    
-- SEQUENCE를 이용해 튜플 삽입
INSERT INTO author(
    author_id,
    author_name,
    author_desc
) VALUES (
    seq_author_id.NEXTVAL,
    '스티븐 킹',
    '쇼생'
);

-- 시퀀스를 위한 딕셔너리?
SELECT *
FROM user_sequences;

SELECT *
FROM user_objects
WHERE object_type = 'SEQUENCE';

-- book 테이블의 pk에 sequence 넣어두기
SELECT *
FROM book;

-- 1에서 시작, 1씩 증가, 캐시없는 시퀀스 생성
CREATE SEQUENCE seq_book_id NOCACHE;