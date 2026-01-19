# 친구 수 집계하기

## 🧠 해결 전략
1. 모든 연결 관계가 행으로 저장되어 있지 않음
    1. 예시: 
        1. `user_a_id` = 1 → `user_b_id` = 59 (O)
        2. `user_a_id` = 59 → `user_b_id` = 1 (X)
    2. 따라서, `UNION ALL` 을 사용하여 친구 관계 종합 → 임시 테이블(`total_edges`)
2. `total_edges` 에서 `GROUP BY`를 사용해 user_id별 친구 수 집계 → 임시 테이블(`total_friends`)
3. 모든 사용자 정보를 담고 있는 `users` 테이블과 `total_friends` 테이블을 LETT JOIN
    1. 모든 사용자에 대한 친구 수 정보를 확인하기 위해
    2. 친구 수가 없는 `user_id` 는 `IFNULL`을 사용하여 NULL → 0으로 변경

## 🧾 SQL 풀이
```sql
-- 테이블 edges: 사용자의 친구 관계 정보
-- - 각 행의 user_a_id, user_b_id 는 서로 친구

-- DB 내 모든 사용자에 대해 각 사용자의 친구 수 집계
-- - 친구 수가 많은 사용자부터 출력, 친구 수가 같으면 사용자 ID가 작은 순

-- -- 1 -> 59
-- SELECT
--   *
-- FROM edges
-- LIMIT 5;

-- -- 59 -> 1이 없음
-- SELECT
--   *
-- FROM edges
-- WHERE user_a_id = 59
-- ORDER BY user_b_id ASC
-- LIMIT 5

-- SELECT
--   COUNT(*)
-- FROM edges
-- -- 84243

WITH total_edges AS (
  (SELECT
    user_a_id AS user_id
    ,user_b_id AS friend_id
  FROM edges)
  UNION ALL
  (SELECT
    user_b_id AS user_id
    ,user_a_id AS friend_id
  FROM edges)
), total_frends AS (
SELECT
  user_id
  ,COUNT(friend_id) AS num_friends
FROM total_edges
GROUP BY user_id
)
SELECT
  u.user_id
  -- ,tf.num_friends
  ,IFNULL(tf.num_friends, 0) AS num_friends
FROM users u
LEFT JOIN total_frends tf ON u.user_id = tf.user_id
-- WHERE tf.num_friends IS NULL
ORDER BY num_friends DESC, user_id ASC
-- LIMIT 5
```

## ✅ 개념 정리
1. 문제를 잘 읽자!
    1. 문제 → “데이터베이스에 포함된 모든 사용자에 대해”
    2. `edges` 테이블만 살펴봄
        1. `edges` 테이블은 사용자의 친구 관계 정보만 들어있음
        2. 데이터베이스에 포함된 모든 사용자가 아닌 일부임
