# 멘토링 짝꿍 리스트
## 🧠 해결 전략

1. `TIMESTAMPDIFF` 를 사용하여 재직 기간 계산
    1. 재직 기간 = 기준일 - 입사일
2. 멘토, 멘티 각 그룹을 `CTE`로 저장
    1. 재직 기간이 3개월 이내 → 멘티
    2. 재직 기간이 2년(24개월) 이상 → 멘토
3. 멘티 그룹 테이블을 기준으로 `LEFT JOIN` 매핑
    1. 이 때, `ON mentees.department != mentors.department` 으로 서로 다른 부서끼리 매칭되도록 함

## 🧾 SQL 풀이

```sql

WITH mentees AS (
  SELECT
    *
    ,TIMESTAMPDIFF(MONTH, join_date, "2021-12-31") AS period
  FROM employees
  WHERE TIMESTAMPDIFF(MONTH, join_date, "2021-12-31") <= 3
), mentors AS(
SELECT
    *
    ,TIMESTAMPDIFF(MONTH, join_date, "2021-12-31") AS period
  FROM employees
  WHERE TIMESTAMPDIFF(MONTH, join_date, "2021-12-31") >= 24
)  
SELECT
  mentees.employee_id AS mentee_id
  ,mentees.name AS mentee_name
  -- ,mentees.department AS mentee_dep
  ,mentors.employee_id AS mentor_id
  ,mentors.name AS mentor_name
  -- ,mentors.department AS mentors_dep
FROM mentees 
LEFT JOIN mentors ON mentees.department != mentors.department
ORDER BY mentee_id ASC, mentor_id ASC
-- LIMIT 10

```

## ✅ 개념 정리
1.
