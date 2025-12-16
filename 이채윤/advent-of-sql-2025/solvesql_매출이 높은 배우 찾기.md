# 매출이 높은 배우 찾기
## 🧠 해결 전략

1. 결제 정보 테이블 기준으로 배우 테이블까지 `JOIN`
2. 상위 5명의 정보는 `ORDER BY DESC` 후 `LIMIT` 로 출력

## 🧾 SQL 풀이

```sql
SELECT 
  -- a.actor_id
  a.first_name
  ,a.last_name
  ,SUM(p.amount) AS total_revenue
FROM payment p
JOIN rental r ON r.rental_id = p.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_actor fa ON fa.film_id = i.film_id
JOIN actor a ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY total_revenue DESC
LIMIT 5
```

## ✅ 개념 정리

1.
