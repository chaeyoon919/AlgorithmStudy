# 레스토랑 요일별 구매금액 Top3 영수증
## 🧠 해결 전략

1. 윈도우 함수 `DENSE_RANK()` 를 사용하여 요일별로 결제 금액 순위를 매김
    1. 같은 가격이면 같은 순위를 매기기 위해 `DENSE_RANK()` 선택
2. 상위 결제 금액 3개에 해당하는 영수증을 모두 출력하기 위해 `WHERE rn < 4` 를 진행

## 🧾 SQL 풀이

```sql
WITH tips_rn AS (
  SELECT
    day
    ,time
    ,sex
    ,total_bill
    ,DENSE_RANK() OVER(PARTITION BY day ORDER BY total_bill DESC) AS rn
  FROM tips
)
SELECT
  day
  ,time
  ,sex
  ,total_bill
FROM tips_rn
WHERE rn < 4
```

## ✅ 개념 정리

1. 윈도우 — 순위 함수
    1. 행을 제거하지 않고, ORDER BY 기준으로 각 행에 순번(순위)를 부여하는 함수
        
        ```sql
        함수명() OVER (
          PARTITION BY ...
          ORDER BY ...
        )
        ```
        
    2. 종류
        
        
        | **함수** | **핵심 역할** |
        | --- | --- |
        | ROW_NUMBER() | 무조건 고유 번호(일련 번호) |
        | RANK() | 공동 순위 허용, 다음 순위 건너뜀 |
        | DENSE_RANK() | 공동 순위 허용, 순위는 연속 |
        | NTILE(n) | 데이터를 n개 그룹으로 분할 |
