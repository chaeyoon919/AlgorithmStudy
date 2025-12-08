## 🧠 해결 전략
1. `윈도우 함수`를 사용하여 조건별 평균값 산출
2. 산출된 평균값을 기준으로 조건 필터링


## 🧾 SQL 풀이
```sql
SELECT
    color
    ,fixed_acidity
    ,volatile_acidity
    ,citric_acid
    ,residual_sugar
    ,chlorides
    ,free_sulfur_dioxide
    ,total_sulfur_dioxide
    ,density
    ,pH
    ,sulphates
    ,alcohol
    ,quality
FROM (
  SELECT
    *
    ,AVG(density) OVER () AS avg_den
    ,AVG(residual_sugar) OVER () AS avg_rs
    ,AVG(pH) OVER (PARTITION BY color) AS avg_ph
    ,AVG(citric_acid) OVER (PARTITION BY color) AS avg_ca
  FROM wines
) calc_avg
WHERE 1=1
AND color = 'white'
AND quality >= 7
AND density > avg_den
AND residual_sugar > avg_rs
AND pH < avg_ph
AND citric_acid > avg_ca
;
```

## ✅ 개념 정리
1. 서브 쿼리
    : 쿼리 안에 또 다른 SELECT 쿼리를 넣어 계산하는 방식
    : 필요한 값을 먼저 계산하고 그 결과를 메인 쿼리에서 사용하는 구조
    - 장점
        - 가장 직관적이고 단순함
        - 특정 계산을 조건식에서 바로 사용할 수 있음
        - 대부분의 DB에서 최적화가 잘 되어 있음
    - 단점
        - 같은 계산을 여러 번 반복하면 비효율적(중복 발생)
        - 구조적으로 쿼리가 싶어져서 복잡해질 수 있음
        - 재사용이 어려움 -> 한 번 계산하면 끝
    - 언제 사용하면 좋은가?
        - 조건에 딱 1회 평균/최댓값/최솟값 등을 비교할 때
        - 간단한 문제의 즉시 해결이 목적일 때
        - 복잡한 데이터 구조가 필요 없을 때
    ```
    SELECT *
    FROM orders
    WHERE order_date = (
    SELECT MAX(order_date)
    FROM orders
    WHERE customer_id = 1
    );
    ```
2. CTE (WITH 절)
    : WITH 절로 임시 테이블을 만들어 놓고 아래 쿼리에서 재사용하는 방식
    : 복잡한 쿼리를 여러 단계로 나누고 싶을 때 최적
    - 장점
        - 복잡한 로직을 단계별로 설명 가능
        - 재사용 가능(같은 CTE 여러번 조인 가능)
        - 유지보수와 협업에 강함
    - 단점
        - 쿼리가 길어짐
        - 일부 DB에서는 CTE가 최적화 장벽이 될 수 있음
    - 언제 사용하면 좋은가?
        - 쿼리가 여러 단계로 나누어지는 경우
        - 중간 계산을 재사용해야 하는 경우
        - 복잡한 조건을 구조적으로 정리하고 싶은 경우
    ```
    WITH expensive AS (
        SELECT * 
        FROM product
        WHERE price > 100
    )
    SELECT *
    FROM expensive
    WHERE category = 'wine';
    ```
3. 윈도우 함수 (Window Function)
    : GROUP BY처럼 데이터를 묶지 ㅇ낳고, 각 행에 통계값(평균, 합계, 순위 등)을 '덧붙이는' 방식
    : e.g., 엑셀에서 "평균" 열을 추가하듯이 작동
    - 장점
        - GROUP BY처럼 행이 줄지 않는다.(행 유지 + 통계 추가)
        - 전체 평균/그룹 평균을 구한 뒤 바로 비교 가능
        - 누적값/순위/슬라이딩 통계 등 고급 분석이 가능
        - 성능이 좋은 경우가 많음(최적화 잘 되어 있음)
    - 단점
        - 너무 많이 쓰면 쿼리가 길어지고 복잡해짐
        - 일부 구형 DB에서는 성능 이슈 존재
    - 언제 사용하면 좋은가?
        - 평균값 기준으로 행을 필터링하려 할 때
        - 집계값을 각 행에 붙이고 싶을 때
        - 누적합/순위/슬라이딩 계산이 필요할 때
        - GROUP BY로는 해결이 안되는 분석 쿼리를 해야 할 때
    ```
    -- e.g., 전체 평균
    SELECT
        price,
        AVG(price) OVER () AS avg_price
    FROM product;

    -- e.g., 그룹별(파티션) 평균
    SELECT
        category,
        price,
        AVG(price) OVER (PARTITION BY category) AS avg_price_by_cat
    FROM product;

    -- e.g., 누적합
    SELECT
        date,
        sales,
        SUM(sales) OVER (ORDER BY date) AS cumulative_sales
    FROM daily_sales;
    ```
