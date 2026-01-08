# 할부는 몇 개월로 해드릴까요

## 🧠 해결 전략

1. `WHERE`  조건문 사용하여 신용카드 주문 내역만 대상
2. `payment_installments` 별로 주문 수, 최소, 최대, 평균 금액을 확인하기 위해 `GROUP BY` 사용
3. 주문 ID가 중복인 경우 제외하기 위해 `DISTINCT` 사용

## 🧾 SQL 풀이

```sql
SELECT
  payment_installments
  ,COUNT(DISTINCT order_id) AS order_count
  ,MIN(payment_value) AS min_value
  ,MAX(payment_value) AS max_value
  ,AVG(payment_value) AS avg_value
FROM olist_order_payments_dataset
WHERE payment_type = "credit_card"
  -- AND payment_installments != 0 
GROUP BY payment_installments
ORDER BY payment_installments

-- SELECT
--   payment_installments
--   , COUNT(order_id)
--   , COUNT(*)
--   , SUM(payment_value)
--   , SUM(payment_value) / COUNT(order_id)
-- FROM olist_order_payments_dataset
-- GROUP BY payment_installments
-- ORDER BY payment_installments
-- LIMIT 5

-- SELECT
--   payment_type
--   ,COUNT(*)
-- FROM olist_order_payments_dataset
-- GROUP BY payment_type

-- -- payment_installments 1, order_count =  25455 -> 25407(정답) 임. 뭐가 문제임?
-- -- order_id의 전체 건수 중에 중복이 있나?
-- SELECT
--   -- payment_installments
--   -- ,COUNT(order_id)
--   COUNT(order_id)
--   ,COUNT(DISTINCT order_id)
-- FROM olist_order_payments_dataset
-- WHERE payment_type = "credit_card"
--   AND payment_installments = 1
-- -- GROUP BY payment_installments
-- LIMIT 10
```

## ✅ 개념 정리

1. 문제를 잘 읽자!
2. 테이블을 잘 살펴보자!
