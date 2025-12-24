# 인플루언서 마케팅 후보 찾기
## 🧠 해결 전략

1. `total_tbl` 파생 테이블 저장하기
    
    ```sql
    SELECT
    	COUNT(DISTINCT user_a_id)
    	,COUNT(DISTINCT user_b_id)
    FROM edges;
    ```
    
    - user_a_id와 user_b_id의 갯수가 동일하지 않음
    - 좀 더 살펴본 결과 1→59는 있는데, 59→1은 없음
        
        
        | user_a_id | user_b_id |
        | --- | --- |
        | 1 | 59 |
        
        | user_b_id | user_a_id |
        | --- | --- |
        | 59 | 108 |
        | 59 | 172 |
        | 59 | ,,, |
    - 예시처럼 1 → 59, 59 → 1 모두 필요하기 때문에 `edges` 테이블 `UNION ALL` 로 합치기
2. `user_friends` 파생 테이블 저장하기
    1. 사용자별 친구 수를 구하기 위해 `user_id` 기준 `GROUP BY` 수행 및 `COUNT(*)` 진행
3. 한 친구(유저 A)의 친구들(유저 B)의 친구 수 합계를 구하기 위해 파생 테이블(`total_tbl`, `user_friend`)의 `JOIN`
    1. 필요한 테이블 구조
        
        
        | user_id | friend_id | friend_cnt |
        | --- | --- | --- |
        | 1 | 200 | 3 |
        | 1 | 300 | 5 |
        | 1 | 400 | 2 |
    2. KEY : 유저 B의 친구 수를 가져오기 위해, `JOIN user_friends uf ON t.friend_id = uf.user_id`
4. `user_id`  로 `GROUP BY`를 걸면 아래처럼 한 유저의 친구 수와 친구의 친구 수 합계 산출 가능
    
    
    | user_id | COUNT(friend_id) | SUM(friend_cnt) |
    | --- | --- | --- |
    | 1 | 3 | 10 |
5. 문제에서 제시한 조건을 걸기 위해 `HAVING` 사용
6. *친구들의 친구 수 합계 / 후보 친구 수* 비율 기준 정렬 후 5개만 뽑기 위해 `LIMIT` 사용

```sql
WITH total_tbl AS (
  SELECT
    user_a_id AS user_id,
    user_b_id AS friend_id
  FROM edges
  UNION ALL
  SELECT
    user_b_id AS user_id,
    user_a_id AS friend_id
  FROM edges
), user_friends AS(
  SELECT
    user_id
    ,COUNT(*) AS friend_cnt
  FROM total_tbl
  GROUP BY user_id)
SELECT
  t.user_id AS user_id
  ,COUNT(t.friend_id) AS friends
  ,SUM(friend_cnt) AS friends_of_friends
  ,ROUND(SUM(friend_cnt) / COUNT(t.friend_id), 2) AS ratio
FROM total_tbl t
JOIN user_friends uf ON t.friend_id = uf.user_id
GROUP BY t.user_id
HAVING COUNT(t.friend_id) >= 100
ORDER BY ROUND(SUM(friend_cnt) / COUNT(t.friend_id), 2) DESC
LIMIT 5

```

## 🧾 SQL 풀이

```sql
-- -- -- -- 유저별 친구 수
-- WITH user_friends AS(
--   SELECT
--     user_a_id AS user_id
--     ,COUNT(user_b_id) AS friends
--   FROM edges
--   GROUP BY user_a_id)
-- SELECT
--   e.user_a_id AS user_id
--   ,COUNT(e.user_b_id) AS friends
--   ,SUM(uf.friends) AS friends_of_friends
--   ,ROUND(COUNT(e.user_b_id)/SUM(uf.friends), 2) AS ratio
-- FROM edges e
-- LEFT JOIN user_friends uf ON e.user_b_id = uf.user_id
-- GROUP BY e.user_a_id
-- HAVING COUNT(e.user_b_id) >= 100
-- LIMIT 5

-- WITH user_friends AS(
--   SELECT
--     user_a_id
--     ,COUNT(*) AS friend_cnt
--   FROM edges
--   GROUP BY user_a_id)
-- SELECT
--   *
--   -- e.user_a_id AS user_id
--   -- ,COUNT(e.user_b_id) AS friends
--   -- ,SUM(friend_cnt) AS friends_of_friends
--   -- ,ROUND(SUM(friend_cnt) / COUNT(e.user_b_id), 2) AS ratio
-- FROM edges e
-- JOIN user_friends uf ON e.user_b_id = uf.user_a_id
-- -- GROUP BY e.user_a_id
-- -- HAVING COUNT(e.user_b_id) >= 100
-- -- ORDER BY ROUND(SUM(friend_cnt) / COUNT(e.user_b_id), 2) DESC
-- LIMIT 5

WITH total_tbl AS (
  SELECT
    user_a_id AS user_id,
    user_b_id AS friend_id
  FROM edges
  UNION ALL
  SELECT
    user_b_id AS user_id,
    user_a_id AS friend_id
  FROM edges
), user_friends AS(
  SELECT
    user_id
    ,COUNT(*) AS friend_cnt
  FROM total_tbl
  GROUP BY user_id)
SELECT
  t.user_id AS user_id
  ,COUNT(t.friend_id) AS friends
  ,SUM(friend_cnt) AS friends_of_friends
  ,ROUND(SUM(friend_cnt) / COUNT(t.friend_id), 2) AS ratio
FROM total_tbl t
JOIN user_friends uf ON t.friend_id = uf.user_id
GROUP BY t.user_id
HAVING COUNT(t.friend_id) >= 100
ORDER BY ROUND(SUM(friend_cnt) / COUNT(t.friend_id), 2) DESC
LIMIT 5

```

## ✅ 개념 정리

1. UNION vs UNION ALL
    1. 여러 SELECT 결과를 하나의 결과 집합으로 합칠 때 사용하는 연산자
    2. UNION: 중복 행을 제거하고 합침
        1. 두 SELECT 결과를 합침
        2. 정렬(SORT) 또는 해시(HASH) 수행
        3. 중복 행 제거(DISTINCT)
        
        ```sql
        SELECT col1, col2 FROM table_a
        UNION
        SELECT col1, col2 FROM table_b;
        ```
        
    3. UNION ALL: 중복 행을 그대로 유지하고 합침
        1. 단순히 위아래로 결과 붙이기
        2. 정렬 X, 중복 제거 X
        
        ```sql
        SELECT col1, col2 FROM table_a
        UNION ALL
        SELECT col1, col2 FROM table_b;
        ```
        
    4. 예시
        
        
        | table_a |
        | --- |
        | id |
        | 1 |
        | 2 |
        
        | table_b |
        | --- |
        | id |
        | 2 |
        | 2 |
        - UNION
            
            
            | id |
            | --- |
            | 1 |
            | 2 |
            | 3 |
        - UNION ALL
            
            
            | id |
            | --- |
            | 1 |
            | 2 |
            | 2 |
            | 3 |
    
    e. 요약표
    
    | **항목** | **UNION** | **UNION ALL** |
    | --- | --- | --- |
    | 중복 제거 | O | X |
    | 정렬/해시 | 필요 | 불필요 |
    | 성능 | 상대적으로 느림 | 빠름 |
    | 대용량 데이터 | 부담 큼 | 적합 |
