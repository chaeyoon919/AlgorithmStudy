## 2022년 8월부터 2022년 10월까지 총 대여 횟수가 5회 이상인 자동차들
## 월별/ 자동차ID별 총 대여횟수
## 대여횟수: RECORDS
## 정렬: 월 asc, 자동차id desc
  
-- 1. 2022년 8월 ~ 10월 사이 총 대여 횟수가 5회 이상인 자동차만 추출
WITH Total5_cars AS (
    SELECT car_id
    FROM car_rental_company_rental_history
    -- start_date를 YYYY-MM 형태로 변환 후 2022-08 ~ 2022-10 범위만 필터링
    WHERE DATE_FORMAT(start_date, '%Y-%m') >= '2022-08'
      AND DATE_FORMAT(start_date, '%Y-%m') <= '2022-10'
    GROUP BY car_id
    HAVING COUNT(*) >= 5   -- ▶ 해당 기간 동안 5회 이상 대여된 자동차만 남김
)

-- 2. 월별 / 자동차별 대여 횟수 구하기
SELECT 
    MONTH(C.start_date) AS MONTH,   -- ▶ start_date에서 월만 추출
    C.CAR_ID,                       -- ▶ 자동차 ID
    COUNT(*) AS RECORDS             -- ▶ 월별 대여 횟수
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY C
JOIN Total5_cars T 
  ON C.car_id = T.car_id            -- ▶ 5회 이상 대여된 자동차만 대상으로 함
WHERE start_date BETWEEN '2022-08-01' AND '2022-10-31'
GROUP BY MONTH, CAR_ID              -- ▶ 월별/자동차별 그룹화
HAVING COUNT(*) >= 1                -- ▶ 해당 월에 최소 1건 이상 대여 기록 존재('특정 월의 총 대여 횟수가 0인 경우에는 결과에서 제외')
ORDER BY 1 ASC, 2 DESC;             -- ▶ 월 오름차순, 자동차 ID 내림차순 정렬
