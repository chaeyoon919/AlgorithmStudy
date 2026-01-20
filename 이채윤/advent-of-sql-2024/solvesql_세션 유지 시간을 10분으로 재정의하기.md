# 세션 유지 시간을 10분으로 재정의하기
## 🎯 요구 사항

- 조건:
    - 세션 종료 기준 수정:  사용자가 **10분 이상** 행동하지 않을 때
    - 사용자 'a8Xu9GO6TB’의 세션을 재정의
        - 재정의한 세션 ID: 1부터 시작해 세션 시작 시간이 빠른 순서대로 1씩 증가하는 자연수
- 추출 스키마:
    - `user_pseudo_id`: 사용자 아이디 (’a8Xu9GO6TB’)
    - `event_timestamp_kst`: 이벤트가 발생한 시각
    - `event_name`: 이벤트 이름
    - `ga_session_id`: 기존 세션 아이디
    - `new_session_id`: 재정의한 세션 아이디
- 정렬: 이벤트 발생 시각이 빠른 순서대로 정렬

## 🧠 해결 전략

1. `tbl_a8Xu9GO6TB`
    1. 사용자 ’a8Xu9GO6TB’만 추출
    2. 직전 이벤트가 발생한 시각을 `LAG()` 를 사용하여 추가
2. `act_tbl`
    1. `TIMESTAMPDIFF()` 를 사용하여 이베트가 발생한 시각과 직전 이벤트가 발생한 시각의 차이 계산
    2. `CASE WHEN ~ END` 를 사용하여 차이가 10분 이상일 경우 1, 아니면 0을 부여 → 세션 종료 기준 표시(`act_yn`)
3. `WINDOW 함수` 와 `SUM`을 사용하여 `act_yn = 1`  이 몇 번 나왔는지를 누적 값으로 구함 →  재정의한 세션 ID 부여
    
    
    | act_yn | new_session_id |
    | --- | --- |
    | 0 | 1 |
    | 0 | 1 |
    | 0 | 1 |
    | 1 | 2 |
    | 0 | 2 |
    | 0 | 2 |
    | 1 | 3 |

## 🧾 SQL 풀이

```sql
WITH tbl_a8Xu9GO6TB AS(
  SELECT
    user_pseudo_id
    ,event_timestamp_kst
    ,event_name
    ,ga_session_id
    ,LAG(event_timestamp_kst) OVER(ORDER BY event_timestamp_kst) AS last_timestamp
  FROM ga
  WHERE user_pseudo_id = "a8Xu9GO6TB"
), act_tbl AS(
  SELECT
    *
    ,CASE WHEN TIMESTAMPDIFF(MINUTE, last_timestamp, event_timestamp_kst) >= 10 THEN 1 ELSE 0 END AS act_yn
  FROM tbl_a8Xu9GO6TB
)
SELECT
  user_pseudo_id
  ,event_timestamp_kst
  ,event_name
  ,ga_session_id
  ,SUM(act_yn) OVER(ORDER BY event_timestamp_kst) + 1 AS new_session_id
FROM act_tbl
ORDER BY event_timestamp_kst

-- -- v2
-- WITH tbl_a8Xu9GO6TB AS(
--   SELECT
--     user_pseudo_id
--     ,event_timestamp_kst
--     ,event_name
--     ,ga_session_id
--     ,LAG(event_timestamp_kst) OVER(ORDER BY event_timestamp_kst) AS last_timestamp
--   FROM ga
--   WHERE user_pseudo_id = "a8Xu9GO6TB"
-- ), act_tbl AS(
--   SELECT
--     *
--     ,CASE WHEN TIMESTAMPDIFF(MINUTE, last_timestamp, event_timestamp_kst) >= 10 THEN 1 ELSE 0 END AS act_yn
--   FROM tbl_a8Xu9GO6TB
-- )
-- SELECT
--   user_pseudo_id
--   ,event_timestamp_kst
--   ,event_name
--   ,ga_session_id
--   ,SUM(act_yn) OVER(ORDER BY event_timestamp_kst ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) + 1 AS new_session_id
-- FROM act_tbl
-- ORDER BY event_timestamp_kst

-- -- v1
-- WITH tbl_a8Xu9GO6TB AS(
--   SELECT
--     user_pseudo_id
--     ,event_timestamp_kst
--     ,event_name
--     ,ga_session_id
--     ,LAG(event_timestamp_kst) OVER(ORDER BY event_timestamp_kst) AS last_timestamp
--   FROM ga
--   WHERE user_pseudo_id = "a8Xu9GO6TB"
-- ), act_tbl AS(
--   SELECT
--     *
--     ,CASE WHEN TIMESTAMPDIFF(MINUTE, last_timestamp, event_timestamp_kst) >= 10 THEN 1 ELSE 0 END AS act_yn
--   FROM tbl_a8Xu9GO6TB
-- ), nsi_tbl AS (
--   SELECT
--     *
--     ,SUM(act_yn) OVER(ORDER BY event_timestamp_kst ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS nsi
--   FROM act_tbl
-- )
-- SELECT
--   user_pseudo_id
--   ,event_timestamp_kst
--   ,event_name
--   ,ga_session_id
--   ,nsi + 1 AS new_session_id
-- FROM nsi_tbl
-- ORDER BY event_timestamp_kst ASC
-- ;
```

## ✅ 개념 정리

1. `TIMESTAMPDIFF(단위, 시작 날짜, 종료 날짜)` 
    1. 두 날짜 또는 시간 값 사이의 차이를 지정된 단위로 계산
    2. `DATEDIFF()` 와의 차이점
        - `DATEDIFF(날짜1, 날짜2)`: 두 날짜 사이의 일(day) 차이만 반환
        - `TIMESTAMPDIFF(unit, start_datetime, end_datetime)`: 원하는 단위로 두 시간 간의 차이를 계산
    3. 지원되는 단위(`unit`) 목록
        - SECOND (초), MINUTE (분), HOUR (시), DAY (일), WEEK (주), MONTH (월), QUARTER (분기), YEAR (연)
2. `LAG()` , `LEAD()`
    1. 윈도우 함수 중에서 **이전 행/다음 행의 값을 현재 행에서 참조**하기 위해 사용
        1. 현재 행은 그대로 두고, 시간 흐름, 순서, 변화량 등을 계산할 때 많이 사용함
    2. LAG() : 이전 행(previous row)의 값을 가져옴
    3. LEAD() : 다음 행(next row)의 값을 가져옴
    4. 기본 문법 구조
        
        ```sql
        LAG(column, offset, default) OVER(PARTITION BY ,,, ORDER BY ,,,)
        LEAD(column, offset, default) OVER(PARTITION BY ,,, ORDER BY ,,,)
        
        -- 각 요소의 의미
        LAG/LEAD(column: 가져올 컬럼, offset(선택): 몇 행 떨어진 값을 가져올지, 기본값 1, 
                 default(선택): 이전/다음 행이 없을 때 반환할 값) OVER(PARTITION BY: 그룹 내에서만 이전/다음 계산 ,,, ORDER BY:(필수!) 행의 "순서" 정의 ,,,)
        
        ```
        
3. `SUM(CASE WHEN ...)` 과 `SUM(CASE WHEN ... ) OVER(...)`의 차이점
    
    
    | `SUM(CASE WHEN ...)` | `SUM(CASE WHEN ... ) OVER(...)` |
    | --- | --- |
    | **집계** : 여러 행 → 1행(또는 그룹당 1행) | **윈도우 집계**: 행 유지 + 계산값 붙임 |
4. `SUM(CASE WHEN ... ) OVER(ORDER BY...)` : 누적/순번 등의 일련번호
    1. 윈도우 함수 내부의 ORDER BY는 **윈도우 함수 계산 순서**를 의미
    (각 행마다, 이 행보다 앞에 있는 행들을 ORDER BY … 기준으로 판단하는 것)
        1. `SELECT … ORDER BY`: 결과 출력 순서(모든 계산이 끝난 후, 결과를 어떤 순서로 보여줄지)
