## 요일별로 가장 높은 금액의 결제내역 - 모든 컬럼 포함
## **결제** 내역: total_bill에 tip 포함
## 윈도우 함수 rank 이용해 같은 요일에서 결제금액(=total_bill+tip)이 가장 큰 행(rank=1)만 남김
with ranked as (    -- CTE
  select *,    --전체 컬럼이 출력되어야 하므로
    rank() over (partition by day order by total_bill+tip desc) as total_rk    -- day별로 결제금액 기준 내림차순으로 rank 부여
  from tips
)
select day, total_bill, tip, sex, smoker, time, size
from ranked
where total_rk = 1;    -- 
