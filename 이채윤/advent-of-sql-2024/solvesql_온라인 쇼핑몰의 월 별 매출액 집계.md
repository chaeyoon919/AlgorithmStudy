# 온라인 쇼핑몰의 월 별 매출액 집계

## 🧠 해결 전략

1. `DATE_FORMAT` 으로 날짜의 `%Y-%m` 분리
2. 연월 별로 집계하기 위해 `GROUP BY` 사용
3. `CASE` 문을 활용해 order_id가 ‘C’로 시작하는 경우와 시작하지 않는 경우의 주문 금액 합계 계산
    1. order_id가 ‘C’로 시작하는지 확인하기 위해 `LIKE` 사용
    2. 주문 금액 합계(`amount`) = 상품 단가(`price`) * 주문 수량(`quantity`)

## 🧾 SQL 풀이

```sql
-- v1
SELECT
  order_month
  ,SUM(CASE WHEN is_cancle = 'not_cancle' THEN amount END) AS ordered_amount
  ,SUM(CASE WHEN is_cancle = 'cancle' THEN amount END) AS canceled_amount
  ,SUM(amount) AS total_amount
FROM 
(SELECT
  -- *
  DATE_FORMAT(o.order_date, "%Y-%m") AS order_month
  ,i.price * i.quantity AS amount
  ,CASE WHEN LEFT(o.order_id, 1) = 'C' THEN 'cancle' ELSE 'not_cancle' END AS is_cancle
FROM orders o
JOIN order_items i ON o.order_id = i.order_id
) agg_tbl
GROUP BY order_month
ORDER BY order_month

-- v2
SELECT
  DATE_FORMAT(o.order_date, "%Y-%m") AS order_month
  ,SUM(CASE WHEN LEFT(o.order_id, 1) != 'C' THEN i.price * i.quantity ELSE 0 END) AS ordered_amount
  ,SUM(CASE WHEN LEFT(o.order_id, 1) = 'C' THEN i.price * i.quantity ELSE 0 END) AS canceled_amount
  ,SUM(i.price * i.quantity) AS total_amount
FROM orders o
JOIN order_items i ON o.order_id = i.order_id
GROUP BY DATE_FORMAT(o.order_date, "%Y-%m")
ORDER BY order_month

-- v3
SELECT
  DATE_FORMAT(o.order_date, "%Y-%m") AS order_month
  ,SUM(CASE WHEN o.order_id NOT LIKE 'C%' THEN i.price * i.quantity ELSE 0 END) AS ordered_amount
  ,SUM(CASE WHEN o.order_id LIKE 'C%' THEN i.price * i.quantity ELSE 0 END) AS canceled_amount
  ,SUM(i.price * i.quantity) AS total_amount
FROM orders o
JOIN order_items i ON o.order_id = i.order_id
GROUP BY DATE_FORMAT(o.order_date, "%Y-%m")
ORDER BY order_month
```

## ✅ 개념 정리

1.
