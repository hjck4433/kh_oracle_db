-- 다중행 함수 : 여러 행에 대해 함수가 적용되어 하나의 결과를 나타내는 함수 (집계 함수)
-- 여러 행이 입력되어 결과가 하나의 행으로 출력
-- GROUP BY : 여러 데이터에서 의미 있는 하나의 결과를 특정 열 값별로 묶어서 출력할 때 사용
SELECT DEPTNO, SUM(SAL), COUNT(*), ROUND(AVG(SAL)), MAX(SAL), MIN(SAL)
FROM EMP
GROUP BY DEPTNO;

SELECT ROUND(AVG(SAL), 2) AS "사원전체 평균"
FROM EMP;

-- 부서별 사원 평균
SELECT DEPTNO, ROUND(AVG(SAL), 2) AS 부서별평균
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;

--GROUP BY 절 없이 구현한다면
SELECT AVG(SAL)FROM EMP WHERE DEPTNO = 10;
SELECT AVG(SAL)FROM EMP WHERE DEPTNO = 20;
SELECT AVG(SAL)FROM EMP WHERE DEPTNO = 30;

-- 집합연산자를 사용하여 구현 하기
SELECT AVG(SAL)FROM EMP WHERE DEPTNO = 10
UNION ALL
SELECT AVG(SAL)FROM EMP WHERE DEPTNO = 20
UNION ALL
SELECT AVG(SAL)FROM EMP WHERE DEPTNO = 30;

-- 부서코드, 급여 합계, 부서 평균, 부서 코드 순 정렬
SELECT DEPTNO 부서코드, 
    SUM(SAL) 합계, 
    ROUND(AVG(SAL), 2) 평균,
    COUNT(*) 인원수 -- 각 그룹에 해당하는 인원이 몇명인지 확인
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;

-- HAVING 절 : GROUP BY 절이 존재하는 경우에만 사용 가능 
-- GROUP BY 절을 통해 그룹화된 결과 값의 범위를 제한할 때 사용

SELECT DEPTNO, JOB, ROUND(AVG(SAL), 2) 평균, COUNT(*)
FROM EMP
GROUP BY DEPTNO, JOB
    HAVING AVG(SAL) >= 2000
ORDER BY DEPTNO, JOB DESC;

-- WHERE 절을 사용하는 경우
SELECT DEPTNO, JOB, ROUND(AVG(SAL), 2) 평균, COUNT(*)
FROM EMP
WHERE SAL >= 1500
GROUP BY DEPTNO, JOB
    HAVING AVG(SAL) >= 1000
ORDER BY DEPTNO, JOB DESC; 

-- EMP테이블(FROM)에서 / SAL 1500이상인 사람들(WHERE)을 / DEPTNO, JOB 그룹(GROUP BY)으로로 묶은 뒤 / 
-- SELECT 항목을 / DEPTNO 오름차순, JOB 내림차순 정렬 (ORDER BY) 해서 정렬

-- 수행 순서 : FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY 


-- 1. 부서별 직책의 평균 급여가 500 이상인 사원들의 부서 번호, 직책, 부서별 직책의 평균 급여 출력
SELECT DEPTNO, JOB, ROUND(AVG(SAL), 2) 평균
FROM EMP
GROUP BY DEPTNO, JOB
    HAVING AVG(SAL) >= 500
ORDER BY DEPTNO, JOB;

-- 2. 부서번호, 평균급여, 최고급여, 최저급여, 사원수를 출력, 단, 평균 급여를 출력 할 때는
-- 소수점 제외하고 부서 번호별로 출력
SELECT DEPTNO "부서 번호", 
    TRUNC(AVG(SAL)) "평균 급여", 
    MAX(SAL) "최고 급여", 
    MIN(SAL) "최저 급여" , 
    COUNT(*) "사원 수"
FROM EMP
GROUP BY DEPTNO;

-- 3. 같은 직책에 종사하는 사원이 3명 이상인 직책과 인원을 출력
SELECT JOB 직책, COUNT(*) "사원 수"
FROM EMP
GROUP BY JOB
    HAVING COUNT(*) >= 3;

-- 4. 사원들의 입사 연도를 기준으로 부서별로 몇 명이 입사했는지 출력
-- TO_CHAR(HIREDATE, 'YYYY')도 가능
SELECT EXTRACT(YEAR FROM HIREDATE) 입사연도 , DEPTNO, COUNT(*) 사원수
FROM EMP
GROUP BY EXTRACT(YEAR FROM HIREDATE), DEPTNO
ORDER BY EXTRACT(YEAR FROM HIREDATE);

-- 5. 추가 수당을 받는 사원 수와 받지 않는 사원수를 출력 (O, X로 표기 필요)
SELECT NVL2(COMM,'O','X') 추가수당, COUNT(*) 사원수
FROM EMP
GROUP BY NVL2(COMM,'O','X');

-- 6. 각 부서의 입사 연도별 사원 수, 최고 급여, 급여 합, 평균 급여를 출력
SELECT DEPTNO, 
    EXTRACT(YEAR FROM HIREDATE) 입사연도, 
    COUNT(*) 사원수, 
    MAX(SAL) 최고급여, 
    SUM(SAL) 급여합, 
    TRUNC(AVG(SAL)) 급여평균
FROM EMP
GROUP BY DEPTNO, EXTRACT(YEAR FROM HIREDATE)
ORDER BY DEPTNO, EXTRACT(YEAR FROM HIREDATE);

-- 그룹화와 과련된 여러 함수 : ROLLUP, CUBE ...
SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), AVG(SAL)
FROM EMP
GROUP BY DEPTNO, JOB
ORDER BY DEPTNO, JOB;

-- ROLLUP : 명시한 열을 소그룹부터 대그룹의 순서로 각 그룹별 결과를
-- 출력하고 마지막에 총 데이터 결과를 출력
-- 각 부서별 중간 결과를 보여 줌
SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), AVG(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB);

-- 조인 : 두 개 이상의 테이블에서 데이터를 가져와서 연결하는데 사용하는 SQL 기능
-- RDMS에서는 테이블 설계시 무결성 원칙으로 인해 동일한 정보가 여러 군데 존재하면 안되기 때문에
-- 필연적으로 테이블을 관리 목적에 맞게 설계 함.
SELECT * FROM EMP, DEPT;

-- 열 이름을 비교하는 조건식으로 조인하기
SELECT * 
    FROM EMP, DEPT 
    WHERE EMP.DEPTNO = DEPT.DEPTNO
ORDER BY EMPNO;

-- EMP // EMPNO => PRIMARY KEY / DEPTNO => FOREIGN KEY
-- DEPT // DPTNO => PRIMARY KEY

-- 테이블 별칭 사용하기
SELECT *
    FROM EMP E, DEPT D
    WHERE E.DEPTNO = D.DEPTNO
ORDER BY EMPNO;

-- 조인 종류 : 두 개 이상의 테이블을 하나의 테이블처럼 가로로 늘려서 출력하기 위해 사용
-- 조인은 대상 데이터를 어떻게 연결하느냐에 따라 등가, 비등가, 자체, 외부 조인으로 구분
-- 등가 조인 : 테이블을 연결한 후 출력 행을 각 테이블의 특정 열에 일치한 데이터를 기준으로 선정하는 방식
-- 등가 조인에는 안시(ANSI) 조인과 오라클 조인이 있음

-- 오라클 조인
SELECT EMPNO, ENAME, D.DEPTNO, DNAME, LOC
    FROM EMP E, DEPT D
    WHERE E.DEPTNO = D.DEPTNO
    AND E.DEPTNO = 10
    ORDER BY D.DEPTNO;

SELECT EMPNO, ENAME, D.DEPTNO, SAL, DNAME, LOC
    FROM EMP E, DEPT D
    WHERE E.DEPTNO = D.DEPTNO
    AND SAL >= 3000
    ORDER BY D.DEPTNO;

-- ANSI 조인
SELECT EMPNO, ENAME, D.DEPTNO, SAL, DNAME, LOC
    FROM EMP E JOIN DEPT D
    ON E.DEPTNO = D.DEPTNO
    WHERE SAL >= 3000
    ORDER BY D.DEPTNO;


-- EMP 테이블 별칭을 E로, DEPT 테이블 별칭은 D로 하여 다음과 같이 등가 조인을 했을 때
-- 급여가 2500 이하이고 사원 번호가 9999 이하인 사원의 정보가 출력되도록 작성 (ANSI, 오라클 조인)

-- 오라클 조인
SELECT EMPNO, ENAME, SAL, E.DEPTNO, DNAME, LOC
    FROM EMP E , DEPT D
    WHERE E.DEPTNO = D.DEPTNO -- 동등 조인, 이너 조인(두 테이블이 일치하는 데이터만 선택) 
    AND SAL <= 2500 
    AND EMPNO <= 9999
    ORDER BY EMPNO;

-- ANSI 조인
SELECT EMPNO, ENAME, SAL, E.DEPTNO, DNAME, LOC 
    FROM EMP E JOIN DEPT D
    ON E.DEPTNO = D.DEPTNO
    WHERE SAL <= 2500 
    AND EMPNO <= 9999
    ORDER BY EMPNO;

