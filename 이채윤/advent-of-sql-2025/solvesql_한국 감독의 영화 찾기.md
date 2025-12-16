# 한국 감독의 영화 찾기
## 🧠 해결 전략

1. `LIKE` 를 사용하여, classification 컬럼이 Film으로 시작하는 데이터 찾기
2. `JOIN`을 사용하여, 여러 테이블을 연결시켜, 원하는 정보 찾기

## 🧾 SQL 풀이

```sql
SELECT
  art.name as artist
  ,a.title as title
FROM artworks a
JOIN artworks_artists aa ON a.artwork_id = aa.artwork_id
JOIN artists art ON aa.artist_id = art.artist_id
WHERE 1=1
AND a.classification LIKE 'Film%'
AND art.nationality = "Korean"
```

## ✅ 개념 정리
1.
