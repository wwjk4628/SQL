 -- MySQL은 사용자와 Database를 구분하는 DBMS
SHOW DATABASES;

-- 데이터베이스 사용 선언
USE sakila; 

-- 	데이터베이스 내에 어떤 테이블이 있는가?
SHOW TABLES;

--	테이블 구조 확인
DESC actor;

--	간단한 쿼리 실행
SELECT version(), current_date();
SELECT version(), current_date() FROM dual;

--	특정 테이블 데이터를 조회
SELECT * FROM actor;

--	데이터베이스 생성
--	webdb 데이터베이스 생성
CREATE DAtABASE webdb;
--	시스템 설정에 좌우되는 경우 많음
--	문자셋, 정렬 방식을 명시적으로 지정하는 것이 좋다.
CREATE DATABASE webdb CHARSET utf8mb4
	COLLATE utf8mb4_unicode_ci;
SHOW databases;

-- 사용자 만들기
CREATE USER 'dev'@'localhost' IDENTIFIED BY 'dev';
-- 사용자 비밀번호 변경
-- ALTER USER 'dev'@'localhost' IDENTIFIED BY 'new_password'; 
-- 	사용자 삭제
-- 	DROP USER 'dev'@'localhost';

--  권한 부여
--	GRANT 권한 목록 ON 객체 TO '계정'@'접속호스트';
--  권한 회수
--  REVoKE 권한 목록 ON 객체 FROM  '계정'@'접속호스트';

--	'dev'@'localhost'에게 webdb 데이터 베이스의 모든 객체에 대한 모든 권한 허용 
GRANT ALL privileges ON webdb.* TO 'dev'@'localhost';
-- REVOKE ALL privileges ON webdb.* FROM 'dev'@'localhost';

--     데이터베이스 확인
show databases;

USE webdb;

--	Author 테이블 생성
CREATE TABLE author(
	author_id int primary key,
    author_name varchar(50) not null,
    author_desc varchar(500)
);
show tables;
desc author;

--	테이블 생성 정보
SHOW CREATE TABLE author;

--  book 테이블 생성 (book의 author_id 를 author의 author_id 연결)
CREATE TABLE book(
	book_id int primary key,
    title varchar(100) NOT NULL,
    pubs varchar(100),
    pub_date datetime default now(),
    author_id int,
    CONSTRAINT fk_book FOREIGN KEY (author_id)
    REFERENCES author(author_id)
    );
DESC book;
DROP TABLE book;

--  INSERT : 새로운 레코드 삽입
--	묵시적 방법 : 컬럼 목록 제공하지 않음 -> 선언된 컬럼의 순서대로
INSERT INTO author
VALUES (1, '박경리', '토지 작가');

INSERT INTO author(author_id, author_name)
VALUES (2, '김영하');

SELECT * FROM author;

--	autocommit을 비활성화 autocommit 옵션을 0으로 설정
SET autocommit = 0;

--	MySQL은 명시적 트랜잭션을 수행
START transaction;
SELECT * FROM author;

UPDATE author
SET author_desc = '알쓸신잡 출연'
WHERE author_id = 2;

COMMIT;
ROLLBACK;

--	AUTO_INCREMENT 속성
--	연속된 순차정보, 주로 PK 속성에 사용

--  author 테이블의 PK에 auto_increment 속성 부여
ALTER TABLE author MODIFY author_id INT AUTO_INCREMENT PRIMARY KEY;

--	1. 외래 키 정보 확인
SELECT constraint_name
FROM information_schema.KEY_column_usage
WHERE table_name = 'book';
--	2. 외래 키 삭제 : book 테이블의 FK (fk_book)
ALTER TABLE book DROP FOREIGN KEY fk_book;
--	3. author의 PK에 auto_increment 속성 붙이기
--	기존 PK 삭제
ALTER TABLE author DROP primary key; 
--	AUTO_INCREMENT 속성이 부여된 새로운 PRIMARY KEY 생성 
ALTER TABLE author MODIFY author_id INT AUTO_INCREMENT PRIMARY KEY;
--	4. book의 author_id에 FOREIGN KEY 다시 연결
ALTER TAbLE book
ADD CONSTRAINT fk_book 
foreign key (author_id) references author(author_id);
DESC author;
DESC book;

-- autocommit을 다시 켜줌
SET autocommit = 1;

-- 새로운 AUTO_INCREMENT값을 부여하기 위해 PK 최댓값을 구함
SELECT MAX(author_id) FROM author;
--	새로 생성되는 AUTO_INCREMENT 시작 값을 변경
ALTER TABLE author auto_increment = 3;

-- 테이블 구조 확인
DESCRIBE author;

SELECT * FROM author;


INSERT INTO author (author_name)
VALUES ('스티븐킹');
INSERT INTO author (author_name, author_desc)
values('류츠신', '삼체작가');

--  테이블 생성시 AUTO_INCREMENT 속성을 부여하는 방법
DROP TABLE book CASCADE;

CREATE TABLE book(
	book_id INT AUTO_INCREMENT PRIMARY KEY,
    title varchar(100) NOT NULL,
    pubs varchar(100),
    pub_date DATETIME DEFAULT NOW(),
    author_id INT,
    CONSTRAINT book_fk FOREIGN KEY (author_id)
						references author(author_id)
);

DESC book;

INSERT INTO book (title, pub_date, author_id) 
VALUES ('토지', '1994-03-04', 1);
INSERt INTO book (title, author_id)
VALUES ('살인자의 기억법', 2);
INSERT INTO book (title)
VALUES ('쇼생크 탈출');
UPDATE book
SET author_id = 3
WHERE book_id = 3;
INSERT INTO book (title, author_id)
VALUES ('삼체', 4);
SELECT * FROM book;

-- JOIN
SELECT title 제목,
	pub_date 출판일,
	author_name 저자명,
    author_desc '저자 상세'
FROM book b JOIN author a ON b.author_id = b.author_id;