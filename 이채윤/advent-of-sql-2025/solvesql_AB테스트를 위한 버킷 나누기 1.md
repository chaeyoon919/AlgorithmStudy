# A/B 테스트를 위한 버킷 나누기 1

## 🧠 해결 전략

1. `GROUP BY` 를 사용해 고객별 ID를 호출
2. 나머지를 구하기 위해 `%` 사용
3. `CASE WHEN ELSE END` 문을 통해, 조건별 그룹 할당

## 🧾 SQL 풀이

```sql
SELECT 
  customer_id
  ,CASE
    WHEN customer_id%10 = 0 THEN 'A'
    ELSE 'B'
  END AS bucket
FROM transactions
GROUP BY customer_id
ORDER BY customer_id ASC
```

## ✅ 개념 정리
1.
