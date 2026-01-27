# 작품이 없는 작가 찾기
## 🧠 해결 전략

1. MoMA에 등록되어 있는 작가 정보는 `artists` 테이블에 있으므로, 해당 테이블 기준으로 `artworks_artists` 와 `LEFT JOIN` 진행
2. 조건 `WHERE death_year IS NOT NULL` 현재 살아있지 않은 작가들만 필터링
3. 조건 `WHERE ,,, AND artwok_id IS NULL` 로 작품이 없는 작가들만 필터링

## 🧾 SQL 풀이

```sql
SELECT
  a.artist_id
  ,a.name
  -- ,aa.artwork_id
FROM artists a
LEFT JOIN artworks_artists aa ON a.artist_id = aa.artist_id
WHERE death_year IS NOT NULL
  AND artwork_id IS NULL
-- LIMIT 50
```

## ✅ 개념 정리

1.
