# 게임 평점 예측하기 1

## 🧠 해결 전략

1. 누락된 값을 채우기 위한 값 구하기
    1. `GROUP BY` 를 이용하여 장르별 평균 평점 정보 산출
        1. `ROUND` : 반올림
        2. `CEIL` : 올림
2. 테이블 `games` 에 장르별 평균 평점 정보 테이블 `LEFT JOIN`
3. 연도 및 누락된 정보에 대한 기준을 `WHERE` 절에 작성
4. `CASE WHEN` 을 사용하여 누락이면, 평균 정보 기입
    1. `IF(조건, 참일 때 값, 거짓일 때 값)` 도 사용 가능! → *MYSQL에서만*

## 🧾 SQL 풀이

```sql
-- 누락된 정보를 채우기 위한 값: 전체 게임의 평균 평점 및 평론가/사용자 수
SELECT
  game_id
  ,name
  ,CASE WHEN critic_score IS NULL THEN total_cs ELSE critic_score END AS critic_score
  ,CASE WHEN critic_count IS NULL THEN total_cc ELSE critic_count END AS critic_count
  ,CASE WHEN user_score IS NULL THEN total_us ELSE user_score END AS user_score
  ,CASE WHEN user_count IS NULL THEN total_uc ELSE user_count END AS user_count
FROM games g
LEFT JOIN (SELECT
  genre_id
  ,ROUND(AVG(critic_score), 3) AS total_cs
  ,CEIL(AVG(critic_count)) AS total_cc
  ,ROUND(AVG(user_score), 3) AS total_us
  ,CEIL(AVG(user_count)) AS total_uc
FROM games
GROUP BY genre_id) agg_tbl ON g.genre_id = agg_tbl.genre_id
WHERE year >= 2015
AND (critic_score IS NULL
  OR critic_count IS NULL
  OR user_score IS NULL
  OR user_count IS NULL)
```

## ✅ 개념 정리

1.
