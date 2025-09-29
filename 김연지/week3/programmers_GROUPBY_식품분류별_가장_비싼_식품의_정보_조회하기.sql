-- 1. 처음 작성한 코드
SELECT
    CATEGORY,
    MAX(PRICE) AS MAX_PRICE,
    PRODUCT_NAME
FROM
    FOOD_PRODUCT
WHERE
    CATEGORY IN ('과자', '국', '김치', '식용유')
GROUP BY
    CATEGORY
ORDER BY
    MAX_PRICE DESC;

-- 위 코드에서는 각 카테고리별로 PRICE가 가장 높은 값을 뽑아오기는 하지만 그에 해당하는 상품명이 뭔지는 가져올 수 없다.
-- Why? GROUP BY를 하면서 기존의 값들은 저장되지 않고 그냥 집계 함수랑 사용되거나 하기 때문. 각각의 행을 모두 저장하고 있지 않다.
-- 그래서 애초에 최댓값을 찾을 때 그에 해당하는 행을 다 가져오기 위해 WHERE 절에 최댓값을 가지는 행들을 모두 받아온다. (서브쿼리)
-- 그리고 메인 쿼리에서 각 카테고리, 가격이랑 맞는 행을 찾아서 그 행의 PRODUCT_NAME을 가져오도록 쿼리를 작성한다.

-- 코드를 입력하세요
SELECT
    CATEGORY,
    PRICE AS MAX_PRICE,
    PRODUCT_NAME
FROM
    FOOD_PRODUCT
WHERE (CATEGORY, PRICE) IN (
        SELECT
            CATEGORY, MAX(PRICE)
        FROM
            FOOD_PRODUCT
        WHERE
            CATEGORY IN ('과자', '국', '김치', '식용유')
        GROUP BY
            CATEGORY)
ORDER BY
    MAX_PRICE DESC;