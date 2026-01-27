# 배송 예정일 예측 성공과 실패

## 🧠 해결 전략

1. `DATE` 를 사용하여 “YYYY-MM-DD HH:MM:SS” 에서 날짜 부분만 뽑기 (`purchase_date` )
2. `WHERE` 조건에서 아래 항목만 가져오도록 필터
    1. 2017년 한 달 (2017-01-01~2017-01-31)
    2. 배송 완료(`order_delivered_customer_date`), 배송 예정(`order_estimated_delivery_date`) 제외
3. `GROUP BY` 를 사용하여 배송 일자별 집계
4. `CASE WHEN` 을 사용하여, 배송 완료 ≤ 배송 예정 인 경우 1 → 합산(`SUM`) → `success`  와 `CASE WHEN` 을 사용하여, 배송 완료 > 배송 예정 인 경우 1 → 합산(`SUM`) → `fail` 로 각각 집계

## 🧾 SQL 풀이

```sql
-- v2
SELECT
  DATE(order_purchase_timestamp) AS purchase_date
  ,SUM(CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1 ELSE 0 END) AS success
  ,SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS fail
FROM olist_orders_dataset
WHERE DATE(order_purchase_timestamp) >= "2017-01-01"
  AND DATE(order_purchase_timestamp) < "2017-02-01"
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
GROUP BY DATE(order_purchase_timestamp)
ORDER BY purchase_date

-- v1
WITH tbl_201701 AS(
  SELECT
    DATE(order_purchase_timestamp) AS purchase_date
    ,order_id
    ,order_purchase_timestamp
    ,order_estimated_delivery_date
    ,order_delivered_customer_date
  FROM olist_orders_dataset
  WHERE DATE(order_purchase_timestamp) >= "2017-01-01"
    AND DATE(order_purchase_timestamp) < "2017-02-01"
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
)
SELECT
  purchase_date
  ,COUNT(DISTINCT CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN order_id END) AS success
  ,COUNT(DISTINCT CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN order_id END) AS fail
FROM tbl_201701
GROUP BY purchase_date
ORDER BY purchase_date
;
```

## ✅ 개념 정리
1.
