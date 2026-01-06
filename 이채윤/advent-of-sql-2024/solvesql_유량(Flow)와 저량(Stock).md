# 유량(Flow)와 저량(Stock)
## 🧠 해결 전략

1. `acquisition_date` 가 비어있는 경우 집계에서 제외
2. `YEAR(acquisition_date)`  별 유량(Flow) 지표(연도별 합) 산출
3. `UNBOUNDED PRECEDIND` 을 사용하여 저량(Stock) 지표(누적합) 산출

## 🧾 SQL 풀이

```sql
SELECT
  ac_year AS "Acquisition year"
  ,flow_cnt AS "New acquisitions this year (Flow)"
  ,SUM(flow_cnt) OVER (ORDER BY ac_year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Total collection size (Stock)"
FROM(
  SELECT
    YEAR(acquisition_date) AS ac_year
    ,COUNT(*) AS flow_cnt
  FROM artworks
  WHERE acquisition_date IS NOT NULL
  GROUP BY YEAR(acquisition_date)
  ORDER BY ac_year
) flow_tbl
-- LIMIT 5
```

## ✅ 개념 정리

1. Window 함수 구조
    
    ```sql
    <집계/분석 함수> OVER (
      PARTITION BY ...
      ORDER BY ...
      ROWS | RANGE BETWEEN ... AND ...
    )
    ```
    
    - `PARTITION BY ...` : 데이터를 나눌 기준(그룹)
    - `ORDER BY ...` : 그룹 안에서의 순서
        - 계산 순서 정의
    - `ROWS | RANGE BETWEEN … AND …` : 프레임(현재 행 기준으로 어디까지 계산할 것인가)
        - `ROWS / RANGE` : 계산 범위의 기준
        - `BETWEEN` : 프레임의 시작과 끝
2. PRECEDING vs. FOLLOWING

    | **키워드** | **방향** | **의미** |
    | --- | --- | --- |
    | PRECEDING | ← 과거 | 현재 행 이전 |
    | FOLLOWING | → 미래 | 현재 행 이후 |
    
    ```sql
    -- 최근 2행 이동 합계
    ROWS BETWEEN 1 PRECEDING AND CUREENT ROW
    
    -- 현재 + 다음 행
    ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
    ```
    
    - UNBOUNDED PRECEDING
        - 파티션의 첫 행부터 현재 행까지 전부 포함
            
            ```sql
            SUM(amount) OVER (
              ORDER BY order_date
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            )
            ```
            
4. ROWS vs. RANGE
    - 예시
        
        
        | **row** | **date** | **amount** |
        | --- | --- | --- |
        | 1 | 01-01 | 100 |
        | 2 | 01-02 | 50 |
        | 3 | 01-02 | 70 |
    - ROWS
        
        ```sql
        SUM(amount) OVER (
        	ORDER BY date
        	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
        ```
        
        - 결과
            
            
            | **row** | **결과** |
            | --- | --- |
            | 1 | 100 |
            | 2 | 150 |
            | 3 | 220 |
    - RANGE
        
        ```sql
        SUM(amount) OVER (
        	ORDER BY date
        	RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
        ```
        
        - 결과
            
            
            | **row** | **결과** |
            | --- | --- |
            | 1 | 100 |
            | 2 | 220 |
            | 3 | 220 |
