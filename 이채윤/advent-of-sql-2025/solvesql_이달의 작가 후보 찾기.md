# 이달의 작가 후보 찾기

## 🧠 해결 전략

1. 작가 중 소설 작가를 선별하기 위해 `WHERE genre = 'Fiction`' 진행
2. `GROUP BY` 로 작가별 등재 수, 작품 평균 사용자 평점, 작품 평균 리뷰 수 산출
3. `NESTED SUBQUERY` 를 사용하여 소설 분야 작품들의 평균 리뷰 수 산출
4. 그룹에 조건을 걸기 위해 `HAVING` 을 사용

## 🧾 SQL 풀이

```sql
SELECT
	author
FROM books
WHERE genre = 'Fiction'
GROUP BY author
HAVING COUNT(author) >= 2
  AND AVG(user_rating) >= 4.5
  AND AVG(reviews) >= (SELECT AVG(reviews) FROM books WHERE genre = 'Fiction')
ORDER BY author ASC;

-- # [고민의 흔적]
-- 해결 방법
-- author 기준 group by? 근데 그 다음 그룹화도 진행해야 하니까, group by는 못하고 윈도우 함수 사용
-- 윈도우 함수를 사용해서 2회 이상 작가들만 뽑아내고
-- 해당 작가 작품들의 평균 사용자 평점, 평균 리뷰 수(전체/소셜 분야)를 뽑아내야 함

-- SELECT
--   *
-- FROM (
--   SELECT
--     *
--     ,ROW_NUMBER() OVER(PARTITION BY author) AS author_index
--   FROM books
-- ) books_tbl
-- JOIN books_tbl t1 ON t1.author_index = books_tbl.author_index+1

-- -- 2회 이상 등재한 작가이름(총 116명)
-- WITH candidates AS (
--   SELECT 
--     author
--     ,COUNT(*)
--   FROM books
--   GROUP BY author
--   HAVING COUNT(*) >=2
-- )
-- SELECT
--   DISTINCT author
-- FROM 
--   (SELECT
--     b.*
--     ,AVG(b.user_rating) OVER(PARTITION BY b.author) AS avg_user_rating
--     ,AVG(b.reviews) OVER(PARTITION BY b.author) AS avg_reviews
--     ,AVG(CASE WHEN b.genre = 'Fiction' THEN b.reviews ELSE NULL END) OVER() AS avg_fiction_reviews
--   FROM candidates c
--   LEFT JOIN books b ON c.author = b.author
--   ) avg_tmp
-- WHERE 1=1 
-- AND avg_user_rating >= 4.5
-- AND avg_reviews >= avg_fiction_reviews
-- ORDER BY author ASC

-- -- 2회 이상 등재한 작가
-- SELECT 
--   author
--   ,COUNT(*)
-- FROM books
-- GROUP BY author
-- HAVING COUNT(*) >=2

-- -- 소설 분야 작품의 평균 리뷰 수: 15683.7917
-- SELECT
--   AVG(reviews)
-- FROM books
-- WHERE genre = 'Fiction'

-- -- 위 두개를 합치면
-- SELECT
--   *
--   ,COUNT(*) OVER(PARTITION BY author) AS author_cnt
--   ,AVG(CASE WHEN genre = 'Fiction' THEN reviews ELSE NULL END) OVER() AS avg_fiction_reviews
-- FROM books

-- -- 정답 쿼리 v1
-- WITH books_tmp AS (
--   SELECT
--     *
--     ,COUNT(*) OVER(PARTITION BY author) AS author_cnt
--     ,AVG(CASE WHEN genre = 'Fiction' THEN reviews ELSE NULL END) OVER() AS avg_fiction_reviews
--   FROM books
-- )
-- SELECT
--   DISTINCT author
-- FROM (
--   SELECT
--     *
--     ,AVG(user_rating) OVER(PARTITION BY author) AS avg_user_rating
--     ,AVG(reviews) OVER(PARTITION BY author) AS avg_reviews
--   FROM (
--     SELECT
--       *
--     FROM books_tmp
--     WHERE author_cnt >= 2) AS candidates -- 2회 이상 등재한 작가
-- ) AS tmp
-- WHERE 1 = 1
-- AND genre = 'Fiction' -- ㅋ ,,,,,,,,,, 소설 작가 ,,,,,,,,,,
-- AND avg_user_rating >= 4.5
-- AND avg_reviews >= avg_fiction_reviews
-- ORDER BY author ASC

-- -- 정답 쿼리 v2
-- SELECT 
--   DISTINCT author
-- FROM 
-- (SELECT
--   *
--   ,COUNT(*) OVER(PARTITION BY author) AS author_cnt
--   ,AVG(user_rating) OVER(PARTITION BY author) AS avg_user_rating
--   ,AVG(reviews) OVER() AS avg_f_reviews
--   ,AVG(reviews) OVER(PARTITION BY author) AS avg_reviews
-- FROM books
-- WHERE genre = 'Fiction'
-- ) AS tmp
-- WHERE 1=1
-- AND author_cnt >=2
-- AND avg_user_rating >=4.5
-- AND avg_reviews >= avg_f_reviews
```

## ✅ 개념 정리

1. 서브쿼리(Subquery)
    1. 하나의 SQL 문장 안에 포함된 또 다른 SQL 문장(종속성)
    2. 실행순서: 서브쿼리가 먼저 결과 생성 → 생성된 결과를 메인 쿼리가 받아 최종 결과 도출
        1. 메인 쿼리(Main Query)의 조건이나 데이터 처리를 이해 먼저 실행되어 결과를 반환하는 중첩 쿼리
    3. NESTED SUBQUERY
        1. 서브쿼리가 WHERE절에서 사용된 경우
    
    [참고자료1](https://rhkswn3999.tistory.com/70)
