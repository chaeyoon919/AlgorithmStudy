## 문제 접근 방법
-- 1. 부서별 최고 salary 보유자를 구해야 하므로 "부서별 그룹화+ 최대 salary"
-- 2. 단, 동률(최고 salary를 가진 사람이 여러명)도 포함해야 하므로 group by절+max()함수가 아닌 rank계열 윈도우함수 활용
-- 3. rank() over (partition by 부서id order by salary desc) = 1 조건으로 최고 salary 보유자 필터링
-- 4. 최종 출력은 Department, Employee, Salary 컬럼

## 문제 푼 순서
-- 1. Employee 테이블에서 department별로 salary 내림차순 정렬한 테이블 필요하다고 생각
--   -> rank()로 순위를 매긴 컬럼 값을 추가한 CTE 만들기(Highest_Salary로 저장)
--   with Highest_Salary as (
--     select
--         *,
--         rank() over (partition by departmentID order by salary desc) as rn_salary
--     from Employee E
--   )
-- 2. Department 테이블과 join해 부서이름(name) 가져오고
--   from Highest_Salary H
--   join Department D on H.departmentID = D.id
-- 3. 순위가 1위(rank=1)인 직원만 필터링해 출력
--   where H.rn_salary = 1;

## 작성한 쿼리
with Highest_Salary as (
    select
        *,
        rank() over (partition by departmentID order by salary desc) as rn_salary
    from Employee E
)
select 
    D.name as Department,
    H.name as Employee,
    H.salary as Salary
from Highest_Salary H
join Department D on H.departmentID = D.id
where H.rn_salary = 1;

## 리뷰 및 특이점
-- 처음엔 아무 생각 없이 group by 사용했다가 행 1개만 출력해 실패
-- 동률 출력이 point! 동률 출력이 필요할 경우 반드시 rank, dense_rank를 써야 한다.
-- e.g. rank: 1,2,2,4 / dense_rank: 1,2,2,3
-- 다른 윈도우 함수 LEAD(), LAG()도 숙지하기! e.g. LEAD()는 다음 행값 가져오기, LAG()는 이전 행값 가져오기
