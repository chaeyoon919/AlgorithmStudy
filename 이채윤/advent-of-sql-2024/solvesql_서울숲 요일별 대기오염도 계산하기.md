# 서울숲 요일별 대기오염도 계산하기

## 🧠 해결 전략

1. `WEEKDAY` 로 입력된 날짜의 요일을 숫자로 반환
2. 반환된 숫자로 `GROUP BY` 진행 및 대기 오염 정보의 평균(`AVG`) 계산
3. 반환된 숫자 기준 `ORDER BY` 오름차순 진행 후 임시 테이블로 저장
4. 임시테이블에서 CASE문으로 반환된 숫자 → *요일로 변경

## 🧾 SQL 풀이

```sql
-- v1
WITH agg_tbl AS(
  SELECT
    WEEKDAY(measured_at) AS daynumber
    ,ROUND(AVG(no2), 4) AS no2
    ,ROUND(AVG(o3), 4) AS o3
    ,ROUND(AVG(co), 4) AS co
    ,ROUND(AVG(so2), 4) AS so2
    ,ROUND(AVG(pm10), 4) AS pm10
    ,ROUND(AVG(pm2_5), 4) AS pm2_5
  FROM measurements
  GROUP BY WEEKDAY(measured_at)
  ORDER BY WEEKDAY(measured_at) 
)
SELECT
  CASE
    WHEN daynumber = '0' THEN '월요일'
    WHEN daynumber = '1' THEN '화요일'
    WHEN daynumber = '2' THEN '수요일'
    WHEN daynumber = '3' THEN '목요일'
    WHEN daynumber = '4' THEN '금요일'
    WHEN daynumber = '5' THEN '토요일'
    WHEN daynumber = '6' THEN '일요일'
  ELSE NULL END AS weekday
  ,no2
  ,o3
  ,co
  ,so2
  ,pm10
  ,pm2_5
FROM agg_tbl

-- v2
SELECT
  CASE WEEKDAY(measured_at)
    WHEN 0 THEN "월요일"
    WHEN 1 THEN "화요일"
    WHEN 2 THEN "수요일"
    WHEN 3 THEN "목요일"
    WHEN 4 THEN "금요일"
    WHEN 5 THEN "토요일"
    WHEN 6 THEN "일요일"
  END AS weekday
  ,ROUND(AVG(no2), 4) AS no2
  ,ROUND(AVG(o3), 4) AS o3
  ,ROUND(AVG(co), 4) AS co
  ,ROUND(AVG(so2), 4) AS so2
  ,ROUND(AVG(pm10), 4) AS pm10
  ,ROUND(AVG(pm2_5), 4) AS pm2_5
FROM measurements
GROUP BY weekday
ORDER BY FIELD(weekday, "월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일")
```

## ✅ 개념 정리

1. `WEEKDAY()`
    1. 입력된 날짜의 요일을 숫자(0~6)으로 반환
        
        
        | **요일** | **반환값** |
        | --- | --- |
        | 월요일 | 0 |
        | 화요일 | 1 |
        | 수요일 | 2 |
        | 목요일 | 3 |
        | 금요일 | 4 |
        | 토요일 | 5 |
        | 일요일 | 6 |
2. `FIELD(expr, v1, v2, ... , vn)`
    1. expr 값이 v1, v2, … , vn 중 몇 번째에 해당하는지(위치 번호)를 반환하는 함수
    2. 예시
        
        ```sql
        FIELD('b', 'a', 'b', 'c') -- 결과: 2
        ```
        
    3. ORDER BY에 쓰면 리스트에 정의한 순서 그대로 정렬할 수 있음
        
        ```sql
        SELECT status
        FROM order
        ORDER BY FIELD(status, 'READY', 'SHIPPED', 'DELIVERED', 'CANCELED');
        
        -- 정렬 결과
        -- 1. READY
        -- 2. SHIPPED
        -- 3. DELIVERED
        -- 4. CANCELED
        -- 5. 리스트에 없는 값들
        ```
