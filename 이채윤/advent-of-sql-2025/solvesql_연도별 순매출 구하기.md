# 연도별 순매출 구하기

## 🧠 해결 전략

1. `YEAR` 을 통해 연도 슬라이싱

## 🧾 SQL 풀이

```sql
SELECT
  YEAR(purchased_at) AS year
  ,SUM(total_price) - SUM(discount_amount) AS net_sales
FROM transactions
WHERE is_returned = 0 -- 반품되지 않은 거래 내역
GROUP BY YEAR(purchased_at) -- 연도별
ORDER BY year ASC -- 연도 기준 오름차순 정렬
```

## ✅ 개념 정리

1.
