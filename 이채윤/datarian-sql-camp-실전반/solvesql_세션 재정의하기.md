# 세션 재정의하기

## 🧠 해결 전략

1. 직전 이벤트 발생 시간과의 차이가 1시간 이상이면 →  새로운 세션 시작
2. 임시 테이블: `sample_tbl`
    1.  `WHERE` 을 사용하여 사용자 `S3WDQCqLpK` 를 필터링 진행
    2. `윈도우 함수 LAG()`  를 사용하여 각 행에 직전 이벤트 발생 시간 값(`last_event_timestamp_kst`) 붙이기
3. 임시 테이블: `diff_tbl`
    1. `TIMESTAMPDIFF()` 를 사용하여 반환값이 1이면, 해당 이벤트는 새 세션의 시작 지점으로 판단
    2. 새 세션 시작 지점을 `SUM() OVER(ORDER BY )` 로 누적합을 구해, 세션 그룹(`new_session_grp`)를 만듬
        1. → 새 세션 시작 지점이 되면 그룹 번호가 1씩 증가함
4. `diff_tbl`
    1. `user_pseudo_id`, `new_session_grp` 그룹별 `MIN()` 은 세션 시작 시간으로 `MAX(` 는세션 종료 시간을 얻을 수 있음

## 🧾 SQL 풀이

```sql
WITH sample_tbl AS (
  SELECT
    user_pseudo_id
    ,ga_session_id
    ,event_name
    ,LAG(event_timestamp_kst) OVER(ORDER BY event_timestamp_kst) AS last_event_timestamp_kst
    ,event_timestamp_kst
    -- ,LEAD(event_timestamp_kst) OVER(ORDER BY event_timestamp_kst) AS next_event_timestamp_kst
  FROM ga
  WHERE user_pseudo_id = "S3WDQCqLpK"
), diff_tbl AS (
  SELECT
    *
    ,CASE
      WHEN TIMESTAMPDIFF(HOUR, last_event_timestamp_kst, event_timestamp_kst) >= 1 THEN 1
      ELSE 0
    END AS diff_1hour
    ,SUM(
      CASE WHEN TIMESTAMPDIFF(HOUR, last_event_timestamp_kst, event_timestamp_kst) >= 1 THEN 1 ELSE 0 END
    ) OVER(ORDER BY event_timestamp_kst) AS new_session_grp
  FROM sample_tbl
)
SELECT
  user_pseudo_id
  -- ,new_session_grp
  ,MIN(event_timestamp_kst) AS session_start
  ,MAX(event_timestamp_kst) AS session_end
FROM diff_tbl
GROUP BY user_pseudo_id, new_session_grp

```

## ✅ 개념 정리

1. 누적합
    1. `SUM(CASE WHEN ...) OVER(ORDER BY ...)`
        - 정렬 기준 컬럼 기준으로 현재 행까지의 모든 이전 행을 누적
        
        ```sql
        SUM(
        	CASE WHEN 조건 THEN 1 ELSE 0 END
        ) OVER (ORDER BY col1)
        
        /*
        - CASE WHEN
            → 각 행을 **더할지(1), 말지(0)** 결정
            
        - ORDER BY col
            → **누적 계산의 진행 순서**를 정의
            
        - 프레임(ROWS BETWEEN ...)을 쓰지 않았기 때문에
            → 기본 프레임이 자동 적용됨
            → RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        */
        ```
        
    2. `SUM(...) OVER(PARTITION BY ... ROWS BETWEEN ... AND CURRENT ROW)`
        - 각 파티션(그룹) 안에서 정렬된 순서 기준으로 맨 처음 행부터 현재 행까지 누적
        
        ```sql
        SUM(expr) OVER (
          PARTITION BY col
          ORDER BY col2
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
        
        /*
        - PARTITION BY
        	→ 누적을 그룹 단위로 분리
        	
        - ORDER BY
        	→ 그룹 내에서 누적 순서 정의
        	
        - ROWS BETWEEN ... AND CURRENT ROW
        	→ 누적 범위를 명시적으로 지정
        */
        ```
        
    3. 비교표 
        
        | **구분** | **CASE WHEN + OVER(ORDER BY)** | **ROWS BETWEEN 명시** |
        | --- | --- | --- |
        | 누적합 여부 | O | O |
        | 프레임 정의 | 암묵적 | 명시적 |
        | 기본 프레임 | RANGE | ROWS |
        | tie(동일 값) 영향 | 있음 | 없음 |
        | 가독성 | 보통 | 높음 |
        | 제어력 | 낮음 | 높음 |
    4. range vs. row
        1. range(default)
            1. `OVER (ORDER BY timestamp)`
            2. 값 기준 프레임
            3. 같은 timestamp가 여러 개면 같이 묶여서 누적
        2. row
            1. `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`
            2. 행 기준 프레임
            3. 현재 행까지만 정확히 누적
2. 쪼개보기
    
    ```sql
    ,SUM(
          CASE WHEN TIMESTAMPDIFF(HOUR, last_event_timestamp_kst, event_timestamp_kst) >= 1 THEN 1 ELSE 0 END
        ) OVER(ORDER BY event_timestamp_kst) AS new_session_grp
    ```
    
    - 시간순으로 정렬했을 때, 1시간 이상 끊긴 지점이 지금까지 총 몇 번 나왔는지를 매 행마다 계산하기
    - step1: `ORDER BY` 로 “누적 계산 순서” 정하기
        - `OVER(ORDER BY event_timestamp_kst)`→ 엔진은 데이터를 **event_timestamp_kst 오름차순**으로 한 줄로 세운 다음, 그 순서대로 누적을 계산
        
        | **row** | **event_timestamp_kst** |
        | --- | --- |
        | 1 | 10:00 |
        | 2 | 10:10 |
        | 3 | 10:20 |
        | 4 | 12:00 |
        | 5 | 12:10 |
        | 6 | 13:30 |
    - step2: `CASE WHEN`이 각 행마다 “세션 시작 신호(0/1)을 만듬
        - 먼저 `LAG()`로 직전 시간을 붙인 상태라고 치면:
        - `CASE WHEN`은 **끊김 발생 지점에만 1을 찍는 컬럼(diff flag)**을 만듬
        
        | **row** | **last_event** | **current_event** | **시간차(시간)** | **CASE 결과** |
        | --- | --- | --- | --- | --- |
        | 1 | NULL | 10:00 | NULL | 0 *(보통 0으로 처리)* |
        | 2 | 10:00 | 10:10 | 0 | 0 |
        | 3 | 10:10 | 10:20 | 0 | 0 |
        | 4 | 10:20 | 12:00 | 1+ | 1 ✅ |
        | 5 | 12:00 | 12:10 | 0 | 0 |
        | 6 | 12:10 | 13:30 | 1+ | 1 ✅ |
    - step3: **`SUM() OVER(ORDER BY)`가 “위에서부터 지금까지” 0/1을 더함**
        - 누적합을 계산하면:
        
        | **row** | **diff_flag (0/1)** | **누적합 SUM(…) OVER(ORDER BY …)** |
        | --- | --- | --- |
        | 1 | 0 | 0 |
        | 2 | 0 | 0 |
        | 3 | 0 | 0 |
        | 4 | 1 | 1 |
        | 5 | 0 | 1 |
        | 6 | 1 | 2 |
        - row4에서 1이 처음 등장 → 누적합이 1이 됨
        - row5는 0이지만 “누적합”이니까 1이 유지
        - row6에서 또 1 등장 → 누적합이 2로 증가
        - new_session_grp는 “세션이 새로 시작한 횟수(끊긴 횟수)”를 **그대로 그룹 번호처럼** 쓰게 됨
