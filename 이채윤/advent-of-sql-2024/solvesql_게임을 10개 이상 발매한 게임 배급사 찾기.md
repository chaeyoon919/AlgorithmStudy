# 게임을 10개 이상 발매한 게임 배급사 찾기
## 🧠 해결 전략

1. `게임 배급사` 별 게임 개수를 확인하기 위해 `GROUP BY` 진행
2. 그룹에 조건을 걸기 위해 `HAVING` 사용
- 처음에 틀린 코드 리뷰
    - LIMIT를 해제 안하고 제출함!
    
    ```sql
    SELECT
      -- g.publisher_id
      -- ,COUNT(g.game_id)
      c.name
    FROM games g
    JOIN companies c ON g.publisher_id = c.company_id
    GROUP BY g.publisher_id
    HAVING COUNT(g.game_id) >= 10
    LIMIT 5
    ```
    

## 🧾 SQL 풀이

```sql
SELECT
  -- g.publisher_id
  -- ,COUNT(g.game_id)
  c.name
FROM games g
JOIN companies c ON g.publisher_id = c.company_id
GROUP BY g.publisher_id
HAVING COUNT(g.game_id) >= 10
-- LIMIT 5
```

## ✅ 개념 정리

1.
