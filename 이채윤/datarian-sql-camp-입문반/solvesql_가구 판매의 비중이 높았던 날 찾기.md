# 가구 판매의 비중이 높았던 날 찾기
## 🧠 해결 전략

1. 일자별 주문 수, 카테고리 Furniture 주문 수를 파악하기 위해 `GROUP BY` 를 사용하여 그룹화
2. 일자별 주문 수: `COUNT(DISTINCT order_id)`
    1. order_id 중복이 있어 `DISTINCT` 설정
3. 일자별 카테고리 “Furniture” 주문 수: `COUNT(DISTINCT CASE WHEN category = "Furniture" THEN order_id ELSE NULL END)`
    1. category 가 “Furniture”이면, order_id를 반환 → `DISINCT` → `COUNT` 로 개수 확인
4. 카테고리 Furniture의 주문 비율 = 백분율 계산 `*100`
5. `ROUND(, 2)` 로 반올림 및 소수점 둘째자리까지 출력
6. 그룹별 조건을 걸기 위해 `HAVING` 사용하여 일별 주문 수 10개 이상, 비율이 40% 이상인 날만 출력
7. `ORDER BY` 로 정렬

## 🧾 SQL 풀이

## ✅ 개념 정리

```sql
-- 일별 주문 수가 10개 이상인 날 중 'Furniture' 카테고리 주문 비율이 40% 이상인 날만 출력
-- - 'Furniture' 카테고리 주문 비율 (백분율): 반올림 소수점 둘째자리
-- - 정렬: 주문 비율 높은 순, 날짜 순

-- SELECT
--   COUNT(DISTINCT order_id)
-- FROM records
-- WHERE order_date = " 2020-11-19"
-- LIMIT 10;

-- 1. 일별 주문 수 10개 이상인 날만 추출
-- 2. "Furniture" 주문 비율 구하기(열 추가)
-- 2-1. "Furniture" 일 때의 주문 합 구하기
-- SELECT
--   order_date
--   -- ,COUNT(DISTINCT order_id) AS order_cnt
--   ,SUM(CASE WHEN category = "Furniture" THEN 1 ELSE 0 END) AS furniture
--   ,ROUND(SUM(CASE WHEN category = "Furniture" THEN 1 ELSE 0 END) / COUNT(DISTINCT order_id) * 100, 2) AS furniture_pct
-- FROM records
-- GROUP BY order_date
-- HAVING COUNT(DISTINCT order_id) >= 10
--   AND ROUND(SUM(CASE WHEN category = "Furniture" THEN 1 ELSE 0 END) / COUNT(DISTINCT order_id) * 100, 2) >= 40
-- ORDER BY furniture_pct DESC, order_date
-- -- ,, 틀림 ,, 왜 ,, ? 

-- -- 테이블 들여다보기
-- SELECT
--   -- DISTINCT
--   order_date
--   -- order_id
--   ,category
--   ,COUNT(order_id)
--   ,COUNT(DISTINCT order_id)
-- FROM records
-- GROUP BY order_date, category
-- HAVING  category = "Furniture"
--   -- AND order_date = "2020-12-01"
-- LIMIT 50

-- SELECT
--   order_date
--   ,order_id
--   ,category
-- FROM records
-- WHERE order_date = "2020-03-27" AND category = "Furniture"
-- -- furniture 건수도 order_id 기준 중복 존재 -> 제외 필요

-- v1
WITH orders AS (
  SELECT
    order_date
    ,COUNT(DISTINCT order_id) AS "orders"
  FROM records
  GROUP BY order_date
  HAVING orders >= 10
), furnitures AS (
  SELECT
    order_date
    -- ,category
    -- ,COUNT(order_id)
    ,COUNT(DISTINCT order_id) AS "furniture"
  FROM records
  GROUP BY order_date, category
  HAVING category = "Furniture"
)
SELECT
  o.order_date
  -- ,o.orders
  ,f.furniture
  ,ROUND((f.furniture/o.orders)*100, 2) AS furniture_pct
FROM orders o 
JOIN furnitures f ON o.order_date = f.order_date
WHERE ROUND((f.furniture/o.orders)*100, 2) >= 40
ORDER BY furniture_pct DESC, order_date ASC

-- v2
WITH daily AS (
  SELECT
    order_date
    ,COUNT(DISTINCT order_id) AS "cnt_orders"
    ,COUNT(DISTINCT CASE WHEN category = "Furniture" THEN order_id ELSE NULL END) AS "cnt_furnitures"
  FROM records
  GROUP BY order_date
)
SELECT
  order_date
  ,cnt_furnitures AS furniture
  ,ROUND((cnt_furnitures / cnt_orders)*100, 2) AS furniture_pct
FROM daily
WHERE cnt_orders >= 10
  AND ROUND((cnt_furnitures / cnt_orders)*100, 2) >= 40
ORDER BY furniture_pct DESC, order_date ASC
```

1. 점검하자! CASE WHEN의 동작 방식
    1. `CASE WHEN` : 행(row)를 하나씩 보면서 값을 바꾸는 스위치
        1. 각 행마다 어떤 값을 반환할지 결정하는 표현식
            
            ```sql
            CASE
            	WHEN 조건 THEN 값1
            	ELSE 값2
            END
            ```
            
        2. CASE WHEN은 항상 row 단위로 먼저 실행됨 → 그 결과를
            1. DISTINCT가 중복 제거
            2. SUM/COUNT가 합침
            3. OVER가 계산 범위만 바꿈
            
            자세한 건, 아래 상황별 점검에서 확인해보자.
            
    2. 상황별 점검
        1. CASE WHEN 단독으로 쓰일 때 (행 단위 변환)
            
            ```sql
            SELECT
            	order_id
            	,category
            	,CASE WHEN category = "Furniture" THEN 1 ELSE 0 END AS is_furniture
            FROM records;
            ```
            
            - 내부 동작: records의 각 row마다 → category 보고 → 1 또는 0으로 바꿈
                
                
                | **order_id** | **category** | **is_furniture** |
                | --- | --- | --- |
                | 1 | Furniture | 1 |
                | 2 | Technology | 0 |
                | 3 | Furniture | 1 |
        2. DISTINCT + CASE WHEN (중복 제거는 “결과값 기준”)
            
            ```sql
            SELECT
            	DISTINCT
            	cASE WHEN category = "Furniture" THEN "F" ELSE "X" END
            FROM records;
            ```
            
            - 내부 동작: 각 row에서 CASE WHEN 실행 → 값 생성 → 그 결과값에 대해 DISTINCT 적용
                
                
                | **category** | **CASE 결과** |
                | --- | --- |
                | Furniture | F |
                | Furniture | F |
                | Technology | X |
                
                → DISTINCT → {F, X}
                
            - 즉, DISTINCT는 원본 row가 아니라, CASE WHEN의 “결과”를 기준으로 중복 제거
        3. SUM/COUNT + CASE WHEN
            - SUM
                
                ```sql
                SUM(CASE WHEN category = "Furniture" THEN 1 ELSE 0 END)
                ```
                
                - 내부 동작
                    - step1: 행 단위
                        
                        ```
                        Furniture -> 1
                        Technology -> 0
                        Furniture -> 1
                        ```
                        
                    - step2: 그 다음 집계
                        
                        ```sql
                        SUM(1, 0, 1) = 2
                        ```
                        
                        - 조건을 만족한 행만 1로 바꿔서 더함
            - COUNT
                
                ```sql
                COUNT(CASE WHEN category = "Furniture" THEN 1 END)
                ```
                
                - 내부 동작
                    - 조건에 부합하지 않을 때, NULL
                    - COUNT는 NULL 제외
                    
                    ```sql
                    COUNT(1, NULL, 1) = 2
                    ```
                    
            - 정리
                
                
                | **방식** | **조건 불만족 시** | **집계 기준** |
                | --- | --- | --- |
                | SUM(CASE) | 0 | 모든 행 |
                | COUNT(CASE) | NULL | 조건 만족 행만 |
        4. DISTINCT + 집계 + CASE WHEN
            
            ```sql
            COUNT(DISTINCT CASE WHEN category = "Furniture" THEN order_id END)
            ```
            
            - 내부 동작
                1. CASE WHEN 실행 → Furniture면 order_id, 아니면 NULL
                2. DISTINCT 적용 → 중복 order_id 제거
                    1. DISTINCT는 CASE 결과에 대해 적용함!
                3. COUNT → NULL 제외 후 카운트
        5. OVER + CASE WHEN
            
            ```sql
            SUM(
            	CASE WHEN category = "Furniture" THEN 1 ELSE 0 END
            ) OVER (PARTITION BY region)
            ```
            
            - 차이점: GROUP BY가 없고, 결과가 row 수만큼 유지됨
            - 내부 동작
                1. CASE WHEN → row마다 1 or 0
                2. PARITION(region) 단위로 SUM
                3. 결과를 각 row에 다시 붙임
                
                | **egion** | **category** | **결과** |
                | --- | --- | --- |
                | East | Furniture | 3 |
                | East | Technology | 3 |
                | East | Furniture | 3 |
        6. OVER + ORDER BY + CASE WHEN
            
            ```sql
            SUM(
            	CASE WHEN category = "Furniture" THEN 1 ELSE 0 END
            ) OVER (
            	PARTITION BY region
            	ORDER BY order_date	
            )
            ```
            
            - 의미 : region 안에서 날짜 순으로 Furniture 주문이 지금까지 몇 번 나왔는가?
            - 내부 동작
                1. CASE WHEN → row 단위
                2. OVER + ORDER BY → 누적 범위만 조절
