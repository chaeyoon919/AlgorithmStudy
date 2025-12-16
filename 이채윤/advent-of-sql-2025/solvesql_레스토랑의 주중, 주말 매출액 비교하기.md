# 레스토랑의 주중, 주말 매출액 비교하기
## 🧠 해결 전략

1. ``

## 🧾 SQL 풀이

```sql
SELECT
  week
  ,SUM(total_bill) AS sales
FROM 
(SELECT
  *,
  CASE
    WHEN day IN ('Sat', 'Sun') THEN 'weekend'
    ELSE 'weekday'
  END AS week
FROM tips) total
GROUP BY week
ORDER BY sales DESC;
```

## ✅ 개념 정리

1. CASE WHEN ELSE END AS
