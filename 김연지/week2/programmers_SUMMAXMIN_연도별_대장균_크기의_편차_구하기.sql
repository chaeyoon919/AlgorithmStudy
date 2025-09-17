-- 1.연도별로 가장 큰 대장균을 구해서 그 테이블을 기존 ECOLI_DATA 테이블과 JOIN.
-- 2.연도를 기준으로 붙여놨으니까 기존 ECOLI_DATA 테이블에 추가적으로 연도별 대장균의 최대 크기가 붙어있음.
-- 3.이제 각 행별로 최댓값 - 각자의 크기를 계산해서 출력.

-- 코드를 작성해주세요
SELECT
    YEAR(E.DIFFERENTIATION_DATE) AS YEAR,
    M.MAX_SIZE - E.SIZE_OF_COLONY AS YEAR_DEV,
    E.ID
FROM
    ECOLI_DATA E
JOIN (
    SELECT
        YEAR(DIFFERENTIATION_DATE) AS YEAR,
        MAX(SIZE_OF_COLONY) AS MAX_SIZE
    FROM ECOLI_DATA
    GROUP BY YEAR(DIFFERENTIATION_DATE)
) M
ON YEAR(E.DIFFERENTIATION_DATE) = M.YEAR
ORDER BY
    YEAR, YEAR_DEV;