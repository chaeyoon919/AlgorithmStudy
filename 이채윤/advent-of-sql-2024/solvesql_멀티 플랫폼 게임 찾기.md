# 멀티 플랫폼 게임 찾기
## 🧠 해결 전략

1. `WHERE`문을 사용해 2012년 이후 출시된 게임만 남김
2. `CASE WHEN` 으로 메이저 플랫폼 지칭
3. 게임 이름(`name`) 별로 메이저 플랫폼의 개수 집계
    1. 같은 게임이 동일 메이저 플랫폼에 기록될 수 있기 때문에, 서로 다른 메이저 플랫폼을 셀 수 있도록 `DISTINCT` 를 사용

## 🧾 SQL 풀이

```sql
SELECT
  DISTINCT name
  -- ,COUNT(DISTINCT major_platform)
FROM (
  SELECT
    g.*
    ,p.name AS platform_name
    ,CASE
      WHEN p.name IN ("PS3", "PS4", "PSP", "PSV") THEN "Sony"
      WHEN p.name IN ("Wii", "WiiU", "DS", "3DS") THEN "Nintendo"
      WHEN p.name IN ("X360", "XONE") THEN "Microsoft"
      ELSE NULL
    END AS major_platform
  FROM games g
  JOIN platforms p ON g.platform_id = p.platform_id
  WHERE g.year > 2011
) agg_tbl
GROUP BY name
HAVING COUNT(DISTINCT major_platform) > 1
-- LIMIT 5
;
```

## ✅ 개념 정리

1.
