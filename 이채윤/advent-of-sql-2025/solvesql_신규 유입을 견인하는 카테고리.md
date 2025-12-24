# 신규 유입을 견인하는 카테고리
## 🧠 해결 전략

1. 주문 데이터를 담고 있는 `records` 와 고객의 주문 정보(첫 주문, 마지막 주문)를 담고 있는 `customer_stats` 테이블을 `JOIN`
    1. 이 때, key 값은 `customer_id`  와 `order_date=first_order_date`
        1. 같은 고객 & 처음 주문한 일자
        2. 한 사람이 처음 주문한 날은 모두 1개일까?: 아래 코드로 확인
            
            ```sql
            SELECT
               customer_id
               ,COUNT(first_order_date)
             FROM customer_stats
             GROUP BY customer_id
             HAVING COUNT(first_order_date) > 1
             ORDER BY customer_id;
            ```
            
2. 카테고리 조합으로 `GROUP BY` 
3. SELECT 절에서 `COUNT(DISTINCT order_id)` 주문 건수 산출
    1. 주문 건수가 여러 개일 수 있으니 중복 제거

## 🧾 SQL 풀이

```sql
-- 모든 카테고리와 서브 카테고리의 조합
-- 해당 카테고리 조합에 속한 상품이 각 사용자의 첫 구매로 주문된 건수

-- SELECT
--   category
--   ,sub_category
--   ,COUNT(order_id) AS cnt_orders
-- FROM records r
-- JOIN customer_stats cs ON cs.customer_id = r.customer_id
--   AND cs.first_order_date = r.order_date
-- GROUP BY category, sub_category
-- ORDER BY cnt_orders DESC

-- -- 한 사람당 첫 주문이 1개인지 확인
-- SELECT
--   customer_id
--   ,COUNT(first_order_date)
-- FROM customer_stats
-- GROUP BY customer_id
-- HAVING COUNT(first_order_date) > 1
-- ORDER BY customer_id;

SELECT
  category
  ,sub_category
  ,COUNT(DISTINCT order_id) AS cnt_orders
FROM records r
JOIN customer_stats cs ON r.customer_id=cs.customer_id
  AND r.order_date = cs.first_order_date
GROUP BY category, sub_category
ORDER BY cnt_orders DESC
-- LIMIT 10

```

## ✅ 개념 정리

1.
