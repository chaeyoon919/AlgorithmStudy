-- [문제 접근 방법]
-- - 요구사항은 "물고기 종류별 가장 큰 물고기 1마리" 출력
-- - GROUP BY + MAX() 방식도 가능하지만,
--   물고기 ID까지 출력해야 하므로 윈도우 함수가 더 적합
-- - RANK()가 아니라 ROW_NUMBER()를 사용하는 이유:
--     · 문제 조건에서 "가장 큰 물고기는 1마리만 존재"라고 보장
--     · 따라서 동률 처리(동순위)가 필요 없으므로 ROW_NUMBER()로 충분
-- - LENGTH가 NULL이거나 10cm 이하인 경우는 제외해야 하므로
--   WHERE 절에서 필터링 처리

-- [문제 푸는 순서]
-- 1) Fish_Info 테이블에서 물고기 정보 조회
-- 2) Fish_Name_Info 테이블과 조인하여 물고기 이름 매칭
-- 3) 물고기 종류(Fish_Type)별로 길이 내림차순 정렬
-- 4) 윈도우 함수 ROW_NUMBER()로 각 물고기 종류별 순위 매기기
-- 5) 순위 = 1인 행만 추출하여 "가장 큰 물고기" 선택
-- 6) ID, FISH_NAME, LENGTH 컬럼 출력 후 ID 오름차순 정렬

## 서브쿼리 VER.
select ID, FISH_NAME, LENGTH
from 
    (select 
        FI.id, 
        FNI.fish_name, 
        FI.length,
        row_number() over (partition by FI.fish_type order by FI.length desc) as rn
     from Fish_Info FI
     join Fish_Name_Info FNI on FI.fish_type = FNI.fish_type
     where FI.length is not null and FI.length > 10
    ) as ranked
where rn = 1
order by ID asc;
