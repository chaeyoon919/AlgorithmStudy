# 지역별 주문의 특징
## 🧠 해결 전략

(v2 기준)

1. 주문 ID 중복인 경우가 존재함 → `DISTINCT order_id, region, category` 를 사용하여 중복이 제거된 데이터만 활용
2. `CASE WHEN` 와 `SUM` 을 활용하여 집계(합산)할 때, 조건을 평가
    1. 행 단위로 조건 먼저 평가 → 조건을 만족한 행 1로 만듬 → 해당 결과 합산

## 🧾 SQL 풀이

```sql
-- v2
SELECT
  region AS "Region"
  ,SUM(CASE WHEN category = "Furniture" THEN 1 ELSE 0 END) AS "Furniture"
  ,SUM(CASE WHEN category = "Office Supplies" THEN 1 ELSE 0 END) AS "Office Supplies"
  ,SUM(CASE WHEN category = "Technology" THEN 1 ELSE 0 END) AS "Technology"
FROM (
  SELECT
    DISTINCT
    order_id
    ,region
    ,category
  FROM records
) uniq_tbl
GROUP BY region
ORDER BY region 

-- v1
WITH tbl AS (
  SELECT
    DISTINCT order_id
    ,region
    ,category
    ,CASE WHEN category = "Furniture" THEN 1 ELSE 0 END AS fur_yn
    ,CASE WHEN category = "Office Supplies" THEN 1 ELSE 0 END AS os_yn
    ,CASE WHEN category = "Technology" THEN 1 ELSE 0 END AS tech_yn
  FROM records
)
SELECT
  region AS "Region"
  ,SUM(fur_yn) AS "Furniture"
  ,SUM(os_yn) AS "Office Supplies"
  ,SUM(tech_yn) AS "Technology"
FROM tbl
GROUP BY region
ORDER BY region ASC
```

## ✅ 개념 정리
1.
