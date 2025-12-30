# 게임 개발사의 주력 플랫폼 찾기

## 🧠 해결 전략

1. 게임 개발사(`developer_id`)별 플랫폼(`platform_id`)별 판매량 구하기
    1. `GROUP BY` 로 게임 개발사, 플랫폼별 총 판매량 집계 ⇒ `agg_tbl` 임시 테이블로 저장
2. 판매량 최대값을 갖는 플랫폼 추출
    1. `RANK()` 를 사용하여 `agg_tbl` 에서 게임 개발사별 총 판매량이 많은 순으로 순위 매기기 ⇒ `rnk_agg_tbl` 임시 테이블로 저장
    2. `rnk_agg_tbl` 에서 순위가 1위(`rnk = 1`)인 것만 추출

## 🧾 SQL 풀이

```sql
WITH agg_tbl AS (SELECT
  g.developer_id
  ,p.platform_id
  -- ,SUM(g.sales_na) AS sum_sale_na
  -- ,SUM(g.sales_eu) AS sum_sale_eu
  -- ,SUM(g.sales_jp) AS sum_sale_jp
  -- ,SUM(g.sales_other) AS sum_sale_others
  ,SUM(g.sales_na) + SUM(g.sales_eu) + SUM(g.sales_jp) + SUM(g.sales_other) AS total_sales
  -- g.*
  ,p.name AS platform
  ,c.name AS company
FROM games g
JOIN platforms p ON g.platform_id = p.platform_id
JOIN companies c ON c.company_id = g.developer_id
GROUP BY g.developer_id, p.platform_id
), rnk_agg_tbl AS (
SELECT
  *
  -- ,ROW_NUMBER() OVER(PARTITION BY developer_id ORDER BY total_sales DESC) AS rn
  ,RANK() OVER(PARTITION BY developer_id ORDER BY total_sales DESC) AS rnk
FROM agg_tbl)
SELECT
  company AS developer
  ,platform
  ,total_sales AS sales
FROM rnk_agg_tbl
WHERE rnk = 1;
```

## ✅ 개념 정리

1. `ROW_NUMBER()` / `RANK()` / `DENSE_RANK()`
    - 해당 함수들은 인자를 받지 않음
    - `ROW_NUMBER()`
        - 중복되는 순위 없이 순서를 매김
    - `RANK()`
        - 중복에 해당되는 값에는 동일한 순서를 매김
        - 동점 후 번호는 건너뜀
    - `DENSE_RANK()`
        - 중복에 해당되는 값에는 동일한 순서를 매김
        - 번호 연속 유지
    - 예시 테이블
        
        
        | **user_id** | **score** |
        | --- | --- |
        | A | 100 |
        | B | 90 |
        | C | 90 |
        | D | 80 |
        
        ```sql
        SELECT
          user_id,
          score,
          ROW_NUMBER()  OVER(ORDER BY score DESC) AS rn,
          RANK()        OVER(ORDER BY score DESC) AS rnk,
          DENSE_RANK()  OVER(ORDER BY score DESC) AS drnk
        FROM scores;
        ```
        
        - 예상 결과
            
            
            | **user_id** | **score** | rn | rnk | drnk |
            | --- | --- | --- | --- | --- |
            | A | 100 | 1 | 1 | 1 |
            | B | 90 | 2 | 2 | 2 |
            | C | 90 | 3 | 2 | 2 |
            | D | 80 | 4 | 4 | 3 |
