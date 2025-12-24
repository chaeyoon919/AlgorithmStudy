# 이틀 연속 미세먼지가 나빠진 날
## 🧠 해결 전략

1. `셀프 조인` 을 활용해 (두 번) 테이블 결합
    1. 오늘 날짜 + 1 ⇒ 다음날 날짜
    2. 다음날 날짜 + 1 ⇒ 셋째날 날짜
2. 오답) 연산 방법1: `DATE(measured_at + 1)`
    1. 만약, measured_at = 2024-12-31인 경우, DATE(measured_at + 1) = NULL 로 반환됨
3. 정답) 연산 방법2: `DATE_ADD(measured_at, INTERVAL 1 DAY)`
    1. 만약, measured_at = 2024-12-31인 경우, DATE_ADD(measured_at, INTERVAL 1 DAY) = 2025-01-01 로 반환됨
4. 이틀 연속 미세먼지가 나빠지는 걸 판별하기 위해 `pm10_3d > pm10_2d > pm10`  조건 부여
5. 미세먼지 수치가 30㎍/㎥ 이상이 된 날을 판별하기 위해 `pm10_3d >= 30` 조건 부여

## 🧾 SQL 풀이

```sql
-- SELECT
--   -- m1.measured_at AS day1
--   -- ,m1.pm10
--   -- ,m2.measured_at AS day2
--   -- ,m2.pm10 as pm10_day2
--   m3.measured_at AS date_alert
--   -- ,m3.pm10 as pm10_day3
-- FROM measurements m1
-- JOIN measurements m2 ON DATE(m1.measured_at + 1) = m2.measured_at
-- JOIN measurements m3 ON DATE(m2.measured_at + 1) = m3.measured_at
-- WHERE m3.pm10 > m2.pm10 AND m2.pm10 > m1.pm10 AND m3.pm10 >= 30
-- ORDER BY date_alert

-- SELECT
--   measured_at
--   ,date_add(measured_at, interval 1 day)
--   ,date(measured_at + 1)
--   -- ,date(date(20240131) + 1)
--   -- ,date_add(date(20240131), interval 1 day)
-- from measurements

-- SELECT
--   m1.measured_at
--   ,m1.pm10
--   ,m2.measured_at AS day2
--   ,m2.pm10 AS pm10_2d
--   ,m3.measured_at AS date_alert
--   ,m3.pm10 AS pm10_3d
-- FROM measurements m1
-- JOIN measurements m2 ON m2.measured_at = DATE_ADD(m1.measured_at, INTERVAL 1 DAY)
-- JOIN measurements m3 ON m3.measured_at = DATE_ADD(m2.measured_at, INTERVAL 1 DAY)
-- -- WHERE m3.pm10 > m2.pm10 AND m2.pm10 > m1.pm10 AND m3.pm10 >= 30
-- ORDER BY m1.measured_at

-- 정답 !
SELECT
  -- m1.measured_at
  -- ,m1.pm10
  -- ,m2.measured_at AS day2
  -- ,m2.pm10 AS pm10_2d
  m3.measured_at AS date_alert
  -- ,m3.pm10 AS pm10_3d
FROM measurements m1
LEFT JOIN measurements m2 ON m2.measured_at = DATE_ADD(m1.measured_at, INTERVAL 1 DAY)
LEFT JOIN measurements m3 ON m3.measured_at = DATE_ADD(m1.measured_at, INTERVAL 2 DAY)
WHERE m3.pm10 > m2.pm10 AND m2.pm10 > m1.pm10 AND m3.pm10 >= 30
ORDER BY m3.measured_at
```

## ✅ 개념 정리

1. 날짜 연산: 특정 시간을 기준으로 더하거나 빼야 하는 경우
    1. DATE_ADD
        1. 기준 날짜에 입력된 기간만큼 더하는 함수
        2. `DATE_ADD(기준 날짜, INTERVAL )`
        
        ```sql
        -- 현재 시간에 1초 더하기
        SELECT DATE_ADD(NOW(), INTERVAL 1 SECOND);
        -- 현재 시간에 1분 더하기
        SELECT DATE_ADD(NOW(), INTERVAL 1 MINUTE);
        -- 현재 시간에 1시간 더하기
        SELECT DATE_ADD(NOW(), INTERVAL 1 HOUR);
        -- 현재 시간에 1일 더하기
        SELECT DATE_ADD(NOW(), INTERVAL 1 DAY);
        -- 현재 시간에 1달 더하기
        SELECT DATE_ADD(NOW(), INTERVAL 1 MONTH);
        -- 현재 시간에 1년 더하기
        SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR);
        ```
        
    2. DATE_SUB
        1. 기준 날짜에 입력된 기간만큼 빼는 함수
        2. `DATE_SUB(기준 날짜, INTERVAL )`
        
        ```sql
        -- 현재 시간에 1초 빼기
        SELECT DATE_SUB(NOW(), INTERVAL 1 SECOND);
        -- 현재 시간에 1분 빼기
        SELECT DATE_SUB(NOW(), INTERVAL 1 MINUTE);
        -- 현재 시간에 1시간 빼기
        SELECT DATE_SUB(NOW(), INTERVAL 1 HOUR);
        -- 현재 시간에 1일 빼기
        SELECT DATE_SUB(NOW(), INTERVAL 1 DAY);
        -- 현재 시간에 1달 빼기
        SELECT DATE_SUB(NOW(), INTERVAL 1 MONTH);
        -- 현재 시간에 1년 빼기
        SELECT DATE_SUB(NOW(), INTERVAL 1 YEAR);
        ```
