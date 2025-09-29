-- SELECT문 작성할 때 NULL인 컬럼을 채우는 방법
-- COALESCE는 SQL 표준 함수이고, IFNULL은 MySQL에서만 사용이 가능하다 > 전자를 쓰기
-- COALESCE는('변경할 컬럼', '변경할 값')
-- COALESCE는 multiple argument로 여러 값 지정 가능!
-- 코드를 입력하세요
SELECT
    WAREHOUSE_ID,
    WAREHOUSE_NAME,
    ADDRESS,
    COALESCE(FREEZER_YN, 'N')
FROM
    FOOD_WAREHOUSE
WHERE
    WAREHOUSE_NAME LIKE '%경기%';