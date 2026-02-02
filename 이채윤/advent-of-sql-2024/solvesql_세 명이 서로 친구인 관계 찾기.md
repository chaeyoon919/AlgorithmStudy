# 세 명이 서로 친구인 관계 찾기
## 🧠 해결 전략

1. `all_users` 
    1. 테이블 조회 시, 1 → 59 는 존재. 59 → 1은 존재하지 않음
    2. 따라서, `UNION ALL` 을 사용하여 모든 user_id에 대해 친구 사이 관계 정보를 부여
2. `linked_3`
    1. 아래와 같을 때, 3명이 서로 친구 관계임
        1. 홍길동 → 김철수, 김철수 → 이아무개, 이아무개 → 홍길동
    2. 따라서, `SELF JOIN` 으로 친구(`user_b_id`)의 친구(`user_c_id`), 친구의 친구의 친구(`user_d_id`)의 열을 추가
    3. `WHERE` 에서 친구의 친구의 친구(`user_d_id` )가 유저(`user_a_id`)와 같은(=3명이 친구) 행만 추출
3. ID가 3820인 사용자만 추출하기 위해 `WHERE` , `IN` 으로 검색

## 🧾 SQL 풀이

```sql
WITH all_users AS (
  (SELECT
    user_a_id AS user_id
    ,user_b_id AS friend_id
  FROM edges)
  UNION ALL
  (SELECT
    user_b_id AS user_id
    ,user_a_id AS friend_id
  FROM edges)
), linked_3 AS (
  SELECT
    a1.user_id AS user_a_id
    ,a1.friend_id AS user_b_id
    ,a2.friend_id AS user_c_id
    -- ,a3.friend_id AS user_d_id
  FROM all_users a1
  JOIN all_users a2 ON a1.friend_id = a2.user_id
  JOIN all_users a3 ON a2.friend_id = a3.user_id
  WHERE a1.user_id = a3.friend_id
)
SELECT
  *
FROM linked_3
WHERE "3820" IN (user_a_id, user_b_id, user_c_id)
  AND user_a_id < user_b_id
  AND user_b_id < user_c_id
```

## ✅ 개념 정리

1. [공식 유튜브 해설](https://youtu.be/zYRJePhv6t8?si=q4M8Xn_dhQkfAq7D)
    1. 테이블을 조회해보면, 항상 `user_a_id` < `user_b_id` 
    2. 따라서, 아래와 같이 `SELF JOIN` 진행
        1. 예시
            
            
            | t1 | t1 | t2 | t2 | t3 | t3 |
            | --- | --- | --- | --- | --- | --- |
            | a | b | a | b  | a | b |
            | 3820 | 3821 | 3821 | 3822 | 3820 | 3822 |
            | 3821 | 3822 |  |  |  |  |
            | 3820 | 3822 |  |  |  |  |
            | ,,, |  |  |  |  |  |
    
    ```sql
    SELECT
      t1.user_a_id AS user_a_id
      ,t1.user_b_id AS user_b_id
      ,t2.user_b_id AS user_c_id
    FROM edges t1
    JOIN edges t2 ON t1.user_b_id = t2.user_a_id
    JOIN edges t3 ON t1.user_a_id = t3.user_a_id AND t2.user_b_id = t3.user_b_id
    WHERE t1.user_a_id = 3820
      OR t1.user_b_id = 3820
      OR t2.user_b_id = 3820
    ```
