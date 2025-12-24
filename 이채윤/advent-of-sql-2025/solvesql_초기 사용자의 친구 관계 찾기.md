# 초기 사용자의 친구 관계 찾기
## 🧠 해결 전략

1. `해당 친구 관계의 순위` 
    1. 각 row별로 `user_a_id` + `user_b_id` 의 순위를 `ROW_NUMBER()` 를 통해 부여
2. `전체 친구 관계의 수`
    1. 전체 관계의 수를 `OVER` 로 열 추가
3. 정수 나눗셈 함정을 피하기 위해, `rn*1.0`  적용하여 실수 / 정수 → 실수 반환
4. `≤ 0.001` 을 통해 전체 중 상위 0.1% 위치에 있는 값들만 선택

## 🧾 SQL 풀이

```sql
SELECT 
  user_a_id
  ,user_b_id
  ,id_sum
FROM (
  SELECT
    *
    ,user_a_id + user_b_id AS id_sum
    ,ROW_NUMBER() OVER(ORDER BY user_a_id + user_b_id ASC) AS rn
    ,COUNT(*) OVER () AS total_rel
  FROM edges
) AS rel
WHERE rn*1.0/total_rel <= 0.001
;
```

## ✅ 개념 정리

1. SQL의 정수 나눗셈 함정
    1. `/` 연산자: 데이터 타입 규칙을 따르는 연산자로, 결과 타입은 “피연산자의 타입”에 의해 결정
    2. 아래 예시처럼 `INTEGER/INTEGER -> INTEGER`  소수점 이하 버림
        
        ```sql
        SELECT 1/100;
        -- 결과 : 0
        ```
        
    3. 해결 방법
        1. 강제로 실수 만들기
            - `rn * 1.0 / total_rel` 에서 `rn * 1.0` 부분이 DOUBLE / FLOAT. 이후 연산 전부 실수.
            - 또는 `rn / (total_rel * 1.0)`
        2. `CAST`
            - 예시: `CAST(rn AS FLOAT) / total_rel`
2. 윈도우 함수
    - 집계 함수 + row 유지
    - 일반 집계 vs. 윈도우 함수
        
        
        | 일반 집계 | 윈도우 함수 |
        | --- | --- |
        | `SELECT COUNT(*) FROM edges;`  | `SELECT *, COUNT(*) OVER () FROM edges;` |
        | 1 row | 원래 row 수 그대로 |
        | row 정보 사라짐 | 각 row에 **전체 개수가 붙음** |
