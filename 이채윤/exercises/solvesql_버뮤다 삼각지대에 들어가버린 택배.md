# 버뮤다 삼각지대에 들어가버린 택배
## 🧠 해결 전략

1. 택배사에 물건을 보내 배송 시작 되었는데, 고객에게 택배가 아직 도착하지 않은 경우(이하, 버뮤다 삼각지대)
2. `WHERE` 을 사용하여 버뮤다 삼각지대에 해당하는 행만 필터링
3. 택배사 도착 날짜별 주문 건수가 필요하므로, `GROUP BY` , `COUNT(DISTINCT` 진행
    1. `DISTINCT` 를 사용하는 이유: `order_id` 의 중복을 제거하기 위해
4. 2017년 1월 한 달만 확인하기 위해, `HAVING` 을 사용하여 기간 설정
5. `ORDER BY` 로 택배사 도착 날짜 기준 오름차순 정렬

## 🧾 SQL 풀이

```sql
SELECT
  DATE(order_delivered_carrier_date) AS delivered_carrier_date
  ,COUNT(DISTINCT order_id) AS orders
FROM olist_orders_dataset
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NULL
GROUP BY DATE(order_delivered_carrier_date)
HAVING delivered_carrier_date >= "2017-01-01"
  AND delivered_carrier_date < "2017-02-01"
ORDER BY delivered_carrier_date
-- LIMIT 10
```

## ✅ 개념 정리

1.
