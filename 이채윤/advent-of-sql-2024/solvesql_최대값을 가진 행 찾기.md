# 최대값을 가진 행 찾기
## 🧠 해결 전략

1. 내림차순 정렬(`ORDER BY DESC` ) 및 행 개수 제한(`LIMIT`)으로 가장 큰 x, y ID를 추출
2. `UNION ALL` 로 위 두 값을 합침

## 🧾 SQL 풀이

```sql
-- DESC points;

-- 가장 큰 x의 ID
(SELECT
  id
FROM points
ORDER BY x DESC
LIMIT 1)
UNION ALL
-- 가장 큰 y의 ID
(SELECT
  id
FROM points
ORDER BY y DESC
LIMIT 1)
ORDER BY id
```

## ✅ 개념 정리

1.
