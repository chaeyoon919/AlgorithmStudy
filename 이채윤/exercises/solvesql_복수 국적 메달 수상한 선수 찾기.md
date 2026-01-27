# 복수 국적 메달 수상한 선수 찾기
## 🧠 해결 전략

1. `JOIN`을 통해 필요한 테이블 결합 후 `WHERE` 를 사용하여 2000년 이후 메달 수상 기록만 고려함 → `medals_2000`
2. 고려 대상 테이블에서 선수(`athlete_id`)별 국적(`team`) 개수를 집계하기 위해, `GROUP BY` 를 사용함
3. `HAVING` 을 사용하여 국적 개수가 2개 이상인 행만 출력

## 🧾 SQL 풀이

```sql
WITH medals_2000 AS (
  SELECT
    r.*
    ,g.year
    ,g.season
    ,g.city
    ,a.name AS athlete_name
    ,t.team
  FROM records r
  JOIN games g ON r.game_id = g.id
  JOIN teams t ON r.team_id = t.id
  JOIN athletes a ON r.athlete_id = a.id
  WHERE g.year >= 2000
    AND r.medal IS NOT NULL
)
SELECT
  -- athlete_id
  athlete_name
  -- ,COUNT(DISTINCT team)
FROM medals_2000
GROUP BY athlete_id
HAVING COUNT(DISTINCT team) >= 2
ORDER BY athlete_name ASC
-- LIMIT 50
;
```

## ✅ 개념 정리

1.
