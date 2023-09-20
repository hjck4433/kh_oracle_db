CREATE TABLE EMP_DDL(
    EMPNO   NUMBER(4),
    ENAME   VARCHAR2(10),
    JOB     VARCHAR2(9),
    MGR     NUMBER(4),
    HIREDATE DATE,
    SAL     NUMBER(7, 2),
    COMM    NUMBER(7, 2),
    DEPTNO  NUMBER(2)
);

INSERT INTO EMP_DDL VALUES(9000, '안유진', 'IVE', 9000, SYSDATE, 10000, 2000, 10);
INSERT INTO EMP_DDL VALUES(9001, '장원영', 'IVE', 9000, SYSDATE, 10000, 2000, 10);
INSERT INTO EMP_DDL VALUES(9002, '가을', 'IVE', 9000, SYSDATE, 10000, 2000, 10);
INSERT INTO EMP_DDL VALUES(9003, '리즈', 'IVE', 9000, SYSDATE, 10000, 2000, 10);
INSERT INTO EMP_DDL VALUES(9004, '레이', 'IVE', 9000, SYSDATE, 10000, 2000, 10);
INSERT INTO EMP_DDL VALUES(9005, '이서', 'IVE', 9000, SYSDATE, 10000, 2000, 10);
INSERT INTO EMP_DDL VALUES(9006, '민지', '뉴진스', 9000, SYSDATE, 10000, 2000, 10);
INSERT INTO EMP_DDL VALUES(9007, '해림', '뉴진스', 9000, SYSDATE, 10000, 2000, 10);
INSERT INTO EMP_DDL VALUES(9008, '하니', '뉴진스', 9000, SYSDATE, 10000, 2000, 10);
INSERT INTO EMP_DDL VALUES(9009, '해인', '뉴진스', 9000, SYSDATE, 10000, 2000, 10);

INSERT INTO EMP_DDL VALUES(9010, '유나', '잇지', 9000, SYSDATE, 10000, 2000, 10, '+8210-1234-5678');
INSERT INTO EMP_DDL VALUES(9011, '예지', '잇지', 9000, SYSDATE, 10000, 2000, 1000, '+8210-1234-5678');


SELECT * FROM EMP_DDL;

-- 테이블 변경하는 ALTER 
-- ADD : 테이블에 열을 추가
-- RENAME : 열의 이름을 변경
-- MODIFY : 열의 데이터형을 변경
-- DROP : 열을 제거

-- 테이블에 열을 추가 : ADD
ALTER TABLE EMP_DDL
    ADD HP VARCHAR2(20);

-- 테이블의 열 이름 변경 : RENAME
ALTER TABLE EMP_DDL
    RENAME COLUMN HP TO TEL;

-- 테이블의 자료형 변경 : MODIFY * 크기 주의!
ALTER TABLE EMP_DDL
    MODIFY TEL VARCHAR2(16);

ALTER TABLE EMP_DDL
    MODIFY DEPTNO NUMBER(4);


ALTER TABLE EMP_DDL -- 열의 데이터가 있어도 삭제 함
    DROP COLUMN TEL;

-- 테이블 이름을 변경하는 RENAME
RENAME EMP_DDL TO EMP_RENAME;

SELECT * FROM EMP_RENAME;

-- 테이블의 데이터를 삭제하는 TRUNCATE
TRUNCATE TABLE EMP_RENAME; -- DDL 명령어 ROLLBACK 불가

DELETE FROM EMP_RENAME; -- DML 명령어 ROLLBACK 가능

-- 테이블을 삭제하는 DROP
DROP TABLE EMP_RENAME;

COMMIT;

-- 빈값을 허용하지 않는 NOT NULL
CREATE TABLE TABLE_NOTNULL (
    LOGIN_ID VARCHAR2(20) NOT NULL,
    LOGIN_PW VARCHAR2(20) NOT NULL,
    TEL VARCHAR2(20)
);

INSERT INTO TABLE_NOTNULL(LOGIN_ID, LOGIN_PW, TEL) VALUES('JKS2024', 'SPHB8250', NULL);
INSERT INTO TABLE_NOTNULL(LOGIN_ID, LOGIN_PW, TEL) VALUES('JKS2025', 'SPHB8250', '010-1234-5678');
INSERT INTO TABLE_NOTNULL(LOGIN_ID, LOGIN_PW, TEL) VALUES('JKS2026', NULL, '010-1234-5678');

SELECT * FROM TABLE_NOTNULL;

DROP TABLE TABLE_NOTNULL;

-- 중복되지 않는 값 : UNIQUE, NULL은 허용, 테이블 내에 여러 열에 존재가능
CREATE TABLE TABLE_UNIQUE (
    LOGIN_ID VARCHAR2(20) PRIMARY KEY,
    LOGIN_PW VARCHAR2(20) NOT NULL,
    TEL VARCHAR2(20)
);

INSERT INTO TABLE_UNIQUE(LOGIN_ID, LOGIN_PW, TEL) VALUES('JKS2024', 'SPHB8250', NULL);
INSERT INTO TABLE_UNIQUE(LOGIN_ID, LOGIN_PW, TEL) VALUES('JKS2025', 'SPHB8250', NULL);
INSERT INTO TABLE_UNIQUE(LOGIN_ID, LOGIN_PW, TEL) VALUES(NULL, 'SPHB82502222', NULL);

SELECT * FROM TABLE_UNIQUE;

DROP TABLE TABLE_UNIQUE;

-- 다른 테이블과 관계를 맺는 FOREIGN KEY
-- 외래키는 서로 다른 테이블간 관계를 정의하는데 사용하는 제약 조건
-- 참조하고 있는 기본 키의 데이터타입과 일치해야 하며 외래키에 참조되는 기본키는 삭제할 수 없습니다.
CREATE TABLE DEPT_FK (
    DEPTNO NUMBER(2) PRIMARY KEY,
    DNAME  VARCHAR2(14),
    LOC    VARCHAR2(13)
);

CREATE TABLE EMP_FK (
    EMPNO NUMBER(4) PRIMARY KEY,
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9),
    MGR NUMBER(4),
    HIREDATE DATE,
    SAL NUMBER(7,2),
    COMM NUMBER(7,2),
    DEPTNO NUMBER(2) REFERENCES DEPT_FK (DEPTNO)
);

INSERT INTO EMP_FK VALUES(9001, '강백호', '농구', 8000, SYSDATE, 2300, 1200, 20);

INSERT INTO DEPT_FK VALUES(10, '농구부', '서울');

SELECT * FROM
EMP_FK E JOIN DEPT_FK D
ON E.DEPTNO = D.DEPTNO;

-- 데이터 형태와 범위를 정하는 CHECK
-- EX) ID 및 PASSWORD 길이 제한
-- EX) 유효 값 범위 확인 (나이 / 성적 / 전화번호 / 이메일)
CREATE TABLE TABLE_CHECK (
    LOGIN_ID VARCHAR2(20) PRIMARY KEY,
    LOGIN_PWD VARCHAR2(20) CHECK(LENGTH(LOGIN_PWD) > 5),
    TEL VARCHAR2(20)
);

INSERT INTO TABLE_CHECK VALUES('JKS2024', 'SPHB21', '010-5006-4146');

SELECT * FROM TABLE_CHECK;

-- DEFAULT 제약 조건 : 특정 열에 저장할 값이 지정되지 않은 경우 기본값을 지정

CREATE TABLE TABLE_DEFAULT (
    LOGIN_ID VARCHAR2(20) PRIMARY KEY,
    LOGIN_PWD VARCHAR2(20) CHECK(LENGTH(LOGIN_PWD) >= 5),
    TEL VARCHAR2(15) DEFAULT '010-0000-0000'
);

INSERT INTO TABLE_DEFAULT(LOGIN_ID, LOGIN_PWD) VALUES('JKS2024', 'SPHB8250');

SELECT * FROM TABLE_DEFAULT;

DROP TABLE TABLE_DEFAULT;

-- 시퀀스란? 오라클에서 특정 규칙에 맞는 연속적인 숫자를 생성하는 객체
CREATE TABLE DEPT_SEQ (
    DEPTNO NUMBER(2) PRIMARY KEY,
    DNAME  VARCHAR2(14),
    LOC    VARCHAR2(13)
);

CREATE SEQUENCE SEQ_DEPT_SEQUENCE
INCREMENT BY 10 -- 증가값
START WITH 10 -- 시작값
MAXVALUE 90 -- 최대값
MINVALUE 0 -- 최소값
NOCYCLE 
CACHE 2;

INSERT INTO DEPT_SEQ VALUES(SEQ_DEPT_SEQUENCE.NEXTVAL+1,'FRONT1', 'BUSAN1');

SELECT * FROM DEPT_SEQ;

