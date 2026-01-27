# 카테고리별 매출 비율

## 🧠 해결 전략

1. `윈도우 함수` 를 사용하여, 각 그룹별 합계 계산 → `집계함수 OVER(PARTITION BY ,, )` 
2. `윈도우 함수` 를 사용하여, 전체 합계 계산 → `집계함수 OVER()`

## 🧾 SQL 풀이

```sql
WITH agg_records AS(
  SELECT
    DISTINCT
    category
    ,sub_category
    ,ROUND(SUM(sales) OVER(PARTITION BY sub_category),2) AS sales_sub_category
    ,ROUND(SUM(sales) OVER(PARTITION BY category),2) AS sales_category
    ,ROUND(SUM(sales) OVER(),2) AS sales_total
    -- ,sales
  FROM records
)
SELECT
  *
  ,ROUND((sales_sub_category/sales_category)*100, 2) AS pct_in_category
  ,ROUND((sales_sub_category/sales_total)*100, 2) AS pct_in_total
FROM agg_records;
```

## ✅ 개념 정리
1.
