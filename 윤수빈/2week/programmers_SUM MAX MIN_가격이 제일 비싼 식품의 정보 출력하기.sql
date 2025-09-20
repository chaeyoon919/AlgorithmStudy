### 문제 요약
- 테이블: `FOOD_PRODUCT`
- 요구사항: **가격이 가장 비싼 식품 1개**의
  - 식품 ID, 식품 이름, 식품 코드, 식품 분류, 가격을 조회
- 조건: `PRICE` 컬럼 기준 최댓값
- 출력 컬럼명: `PRODUCT_ID, PRODUCT_NAME, PRODUCT_CD, CATEGORY, PRICE

## 답1. 가장 간단한 VER -- LIMIT 활용
SELECT *
FROM FOOD_PRODUCT
ORDER BY PRICE DESC
LIMIT 1;

## 답2. 서브쿼리 + 윈도우함수 VER
SELECT PRODUCT_ID, PRODUCT_NAME, PRODUCT_CD, CATEGORY, PRICE   -- *로 대체 못하고 컬럼명을 다 써줘야 한다는 단점이 있음
FROM (
    SELECT 
            *,
            ROW_NUMBER() OVER (ORDER BY PRICE DESC) AS RN
    FROM FOOD_PRODUCT
) AS S    -- 서브쿼리에서는 반드시 테이블 별칭 붙여줘야 한다! 
WHERE RN = 1;
