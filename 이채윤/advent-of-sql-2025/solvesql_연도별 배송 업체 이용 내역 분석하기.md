# 연도별 배송 업체 이용 내역 분석하기

## 🧠 해결 전략

1. 연도별 집계를 위해 `GROUP BY`를 이용
2. 조건부 집계를 위해 `CASE WHEN` 문을 사용하여, 배송 옵션(Standard/Overnight/Express)별 건수 합산
3. 반품 건수를 일반 배송 이용 실적에 합산하기 위해, `is_returne = 1` 인 경우도 조건부 집계를 통해 산출

## 🧾 SQL 풀이

```sql
SELECT
  YEAR(purchased_at) AS year
  ,SUM(CASE WHEN shipping_method = 'Standard' THEN 1 ELSE 0 END) + SUM(CASE WHEN is_returned = 1 THEN 1 ELSE 0 END) AS standard
  -- ,SUM(CASE WHEN shipping_method = 'Standard' THEN 1 ELSE 0 END) AS standard
  ,SUM(CASE WHEN shipping_method = 'Overnight' THEN 1 ELSE 0 END) AS overnight
  ,SUM(CASE WHEN shipping_method = 'Express' THEN 1 ELSE 0 END) AS express
  -- ,SUM(CASE WHEN is_returned = 1 THEN 1 ELSE 0 END) AS returned
FROM transactions
WHERE is_online_order = 1
GROUP BY YEAR(purchased_at)
ORDER BY year
;

```

## ✅ 개념 정리

1. 조건부 집계
    1. `SUM(CASE WHEN 조건 THEN 1 ELSE 0 END)`
    2. 행을 필터링하지 않고, 조건을 만족하는 행만 집계에 포함시키는 기법
    3. 같은 그룹 안에서 여러 조건을 동시에 계산 가능
2. CASE WHEN
    1. 행마다 새로운 값을 만들어내는 표현식
