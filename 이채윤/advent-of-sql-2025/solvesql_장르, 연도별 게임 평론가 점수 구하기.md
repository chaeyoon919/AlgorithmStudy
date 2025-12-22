# 장르, 연도별 게임 평론가 점수 구하기

## 🧠 해결 전략
1. `GROUP BY`를 사용하여 장르별 집계
2. `조건부집계` 를 사용하여 연도별 평론가 점수 평균 산출

## 🧾 SQL 풀이

```sql
SELECT
  gen.name AS genre
  ,ROUND(AVG(CASE WHEN year = 2011 THEN critic_score ELSE NULL END), 2) AS score_2011
  ,ROUND(AVG(CASE WHEN year = 2012 THEN critic_score ELSE NULL END), 2) AS score_2012
  ,ROUND(AVG(CASE WHEN year = 2013 THEN critic_score ELSE NULL END), 2) AS score_2013
  ,ROUND(AVG(CASE WHEN year = 2014 THEN critic_score ELSE NULL END), 2) AS score_2014
  ,ROUND(AVG(CASE WHEN year = 2015 THEN critic_score ELSE NULL END), 2) AS score_2015
FROM games gam
JOIN genres gen ON gen.genre_id = gam.genre_id
GROUP BY gen.name
;
```

## ✅ 개념 정리
1. 조건부집계
    1. 조건을 만족하는 행만 집계 함수에 포함시키는 기법
    2. `WHERE` 와 `조건부 집계` 의 차이점
        1. `WHERE` : 조건에 맞는 값의 행만 남음, 나머지 정보 사라짐
        2. `조건부 집계` : 모든 행을 유지, 같은 그룹 안에서 여러 조건을 동시에 계산
