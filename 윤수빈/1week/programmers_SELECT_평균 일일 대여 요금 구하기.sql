## 문제 접근
-- 0. CAR_RENTAL_COMPANY_CAR 테이블에서
--  => from CAR_RENTAL_COMPANY_CAR
-- 1. 자동차 종류가 'SUV'인
--  => where절에 car_type='SUV'
-- 2. 평균 일일 대여 요금
-- => avg(daily_fee) 겠구나
-- 3. 평균 일일 대여 요금은 소수 첫 번째 자리에서 반올림
-- => select절에 round(avg(daily_fee))
-- 4. 컬럼명은 AVERAGE_FEE 로 지정
-- => select round(avg(daily_fee)) as average_fee

## 최종 쿼리
SELECT ROUND(AVG(DAILY_FEE)) AS AVERAGE_FEE
FROM CAR_RENTAL_COMPANY_CAR
WHERE CAR_TYPE = "SUV";
