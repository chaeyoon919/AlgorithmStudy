# 3년간 들어온 소장품 집계하기

## 🧠 해결 전략

1. `GROUP BY` 를 이용하여 분류별 집계
2. `YEAR`를 사용하여 `acquistion_date` 의 년도 추출
    1. 해당 년도에 맞으면 1, 아니면 0 → `SUM` → 해당 년도의 소장품 총합

## 🧾 SQL 풀이

```sql
SELECT
  -- *
  classification
  ,SUM(CASE WHEN YEAR(acquisition_date) = 2014 THEN 1 ELSE 0 END) AS "2014"
  ,SUM(CASE WHEN YEAR(acquisition_date) = 2015 THEN 1 ELSE 0 END) AS "2015"
  ,SUM(CASE WHEN YEAR(acquisition_date) = 2016 THEN 1 ELSE 0 END) AS "2016"
  -- ,COUNT(*)
FROM artworks
-- WHERE YEAR(acquisition_date) >= 2014 AND YEAR(acquisition_date) <= 2016
  -- AND acquisition_date IS NULL 
GROUP BY classification
ORDER BY classification
-- LIMIT 10;
```

## ✅ 개념 정리

1.
