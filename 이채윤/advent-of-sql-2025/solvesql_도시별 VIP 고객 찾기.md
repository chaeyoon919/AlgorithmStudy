# 도시별 VIP 고객 찾기
## 🧠 해결 전략

1. 도시별 고객별 집계를 위해 `GROUP BY city_id, customer_id` 그룹화
2. 각 도시별 고객별 순매출 산출 `,SUM(total_price) - SUM(discount_amount)`
3. 각 도시별 최고 순매출 고객을 추출하기 위해, 위 집계 결과를 `파생 테이블`로 저장해두고 `윈도우 함수` 를 사용하여 도시별 순매출이 높은 순으로 일련번호 부여
    1. 각 도시별 가장 높은 순매출을 갖는 row가 일련번호 1번을 가짐
4. 조건으로 일련번호 1만 추출

```sql
WITH agg_tbl AS (
  SELECT
    city_id
    ,customer_id
    ,SUM(total_price) - SUM(discount_amount) AS total_spent
  FROM transactions
  WHERE is_returned = 0 
  GROUP BY city_id, customer_id
  ORDER BY city_id, customer_id
)
SELECT
  city_id
  ,customer_id
  ,total_spent
FROM (
  SELECT
    *
    ,ROW_NUMBER() OVER(PARTITION BY city_id ORDER BY total_spent DESC) AS rn
FROM agg_tbl) rn_agg_tbl
WHERE rn = 1
```

- 틀린 코드 회고
    - `cus_spent`를 만들고 `transaction`에 조인한 버전
        - 한 고객은 여러 건의 거래를 가짐 → 같은 고객의 `total_spent` 가 거래 건수만큼 복제
        - 도시별로 고객을 1번 뽑지 않고, 도시별 거래 중에서 고객 총액이 가장 큰 거래 1줄 추출
        
        ```sql
        -- 고객별 순매출 집계
        WITH cus_spent AS (
          SELECT
            -- transaction_id
            customer_id
            -- ,city_id
            ,SUM(total_price) AS total_p
            ,SUM(discount_amount) AS total_da
            ,SUM(total_price) - SUM(discount_amount) AS total_spent
            -- ,is_returned
          FROM transactions
          WHERE is_returned = 0
          GROUP BY customer_id
        )
        -- 각 도시별 최고 순매출 고객
        SELECT
          city_id
          ,customer_id
          ,total_spent
        FROM (
          SELECT
            transaction_id
            ,t.customer_id
            ,t.city_id
            ,cs.total_spent
            ,ROW_NUMBER() OVER(PARTITION BY t.city_id ORDER BY cs.total_spent DESC) AS rn
          FROM transactions t
          LEFT JOIN cus_spent cs ON cs.customer_id = t.customer_id
        ) tbl1
        WHERE rn = 1
        ;
        ```
        
    - 거래 한 건의 `total_price - discount_amont` 로 바로 순위 매긴 버전
        - 단일 거래(한 건)의 순매출로 랭킹
        - 따라서 도시별 최대 결제(한 건) 고객을 추출
        
        ```sql
        SELECT
          city_id
          ,customer_id
          ,spent AS total_spent
        FROM (
          SELECT
            transaction_id
            ,city_id
            ,customer_id
            ,total_price - discount_amount AS spent
            ,ROW_NUMBER() OVER(PARTITION BY city_id ORDER BY total_price - discount_amount DESC) AS rn
          FROM transactions
          WHERE is_returned = 0
        ) tbl_rn
        WHERE rn = 1
        ```
        

## 🧾 SQL 풀이

```sql
-- -- 고객별 순매출 집계
-- WITH cus_spent AS (
--   SELECT
--     -- transaction_id
--     customer_id
--     -- ,city_id
--     ,SUM(total_price) AS total_p
--     ,SUM(discount_amount) AS total_da
--     ,SUM(total_price) - SUM(discount_amount) AS total_spent
--     -- ,is_returned
--   FROM transactions
--   WHERE is_returned = 0
--   GROUP BY customer_id
-- )
-- -- 각 도시별 최고 순매출 고객
-- SELECT
--   city_id
--   ,customer_id
--   ,total_spent
-- FROM (
--   SELECT
--     transaction_id
--     ,t.customer_id
--     ,t.city_id
--     ,cs.total_spent
--     ,ROW_NUMBER() OVER(PARTITION BY t.city_id ORDER BY cs.total_spent DESC) AS rn
--   FROM transactions t
--   LEFT JOIN cus_spent cs ON cs.customer_id = t.customer_id
-- ) tbl1
-- WHERE rn = 1
-- ;

-- SELECT
--   city_id
--   ,customer_id
--   ,spent AS total_spent
-- FROM (
--   SELECT
--     transaction_id
--     ,city_id
--     ,customer_id
--     ,total_price - discount_amount AS spent
--     ,ROW_NUMBER() OVER(PARTITION BY city_id ORDER BY total_price - discount_amount DESC) AS rn
--   FROM transactions
--   WHERE is_returned = 0
-- ) tbl_rn
-- WHERE rn = 1

WITH agg_tbl AS (
  SELECT
    city_id
    ,customer_id
    ,SUM(total_price) - SUM(discount_amount) AS total_spent
  FROM transactions
  WHERE is_returned = 0 
  GROUP BY city_id, customer_id
  ORDER BY city_id, customer_id
)
SELECT
  city_id
  ,customer_id
  ,total_spent
FROM (
  SELECT
    *
    ,ROW_NUMBER() OVER(PARTITION BY city_id ORDER BY total_spent DESC) AS rn
FROM agg_tbl) rn_agg_tbl
WHERE rn = 1
```

## ✅ 개념 정리

1. 집계 단위 맞추기
    1. 집계 단위로 데이터를 만들어야 그 다음 동작의 의미가 존재함
