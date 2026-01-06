# 폐쇄할 따릉이 정류소 찾기 2

## 🧠 해결 전략
1. 대여/반납 건수가 구분되어 있기 때문에 `UNION ALL` 을 사용하여 대여/반납 날짜, 정류소 정보를 합침
2. 정류소 별로 `CASE` 문 활용하여 2018년 10월 대여/반납 건수, 2019년 10월 대여/반납 건수 산출
3. `WHERE` 절에서 대여/반납 건수가 0인 경우 제외 및 비율이 50 이하인 값 제외

## 🧾 SQL 풀이
```sql
-- WITH rent_2019 AS (
-- SELECT
--   rent_station_id
--   ,COUNT(*) AS rent_cnt
-- FROM rental_history
-- WHERE DATE(rent_at) >= "2019-10-01" AND DATE(rent_at) < "2019-11-01"
-- GROUP BY rent_station_id
-- ), return_2019 AS(
-- SELECT
--   return_station_id
--   ,COUNT(*) AS return_cnt
-- FROM rental_history
-- WHERE DATE(return_at) >= "2019-10-01" AND DATE(return_at) < "2019-11-01"
-- GROUP BY return_station_id
-- )
-- SELECT
--   *
-- FROM rent_2019 r
-- JOIN return_2019 re ON r.rent_station_id = re.return_station_id
-- LIMIT 5

-- WITH rent_tbl AS (
--   (SELECT
--     "2018-10" AS date
--     ,rent_station_id
--     ,COUNT(*) AS rent_cnt
--   FROM rental_history
--   WHERE DATE_FORMAT(rent_at, "%Y-%m") = "2018-10"
--   GROUP BY rent_station_id)
--   UNION ALL
--   (SELECT
--     "2019-10" AS date
--     ,rent_station_id
--     ,COUNT(*) AS rent_cnt
--   FROM rental_history
--   WHERE DATE_FORMAT(rent_at, "%Y-%m") = "2019-10"
--   GROUP BY rent_station_id)
-- )

WITH all_tbl AS (
  (SELECT
    rent_at AS date_at
    ,rent_station_id AS station_id
  FROM rental_history)
  UNION ALL 
  (SELECT
    return_at AS date_at
    ,return_station_id AS station_id
  FROM rental_history)
), agg_tbl AS (
SELECT
  station_id
  ,SUM(CASE WHEN DATE_FORMAT(date_at, "%Y-%m") = "2018-10" THEN 1 ELSE 0 END) AS cnt_2018
  ,SUM(CASE WHEN DATE_FORMAT(date_at, "%Y-%m") = "2019-10" THEN 1 ELSE 0 END) AS cnt_2019
FROM all_tbl
GROUP BY station_id
)
SELECT
  at.station_id
  ,s.name
  ,s.local
  ,ROUND((at.cnt_2019/at.cnt_2018)*100, 2) AS usage_pct
FROM agg_tbl at
JOIN station s ON at.station_id = s.station_id
WHERE (cnt_2019 != 0 OR cnt_2019 != 0)
  AND ROUND((cnt_2019/cnt_2018)*100, 2) <= 50
-- LIMIT 5
```

## ✅ 개념 정리
1.
