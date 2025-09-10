## 문제 접근
-- 핵심 조건: “부모의 형질을 모두 보유한 자식” = 부모의 GENOTYPE 비트가 자식 GENOTYPE 안에 전부 포함되어야 함.
-- 비트마스크 활용: 자식.GENOTYPE & 부모.GENOTYPE = 부모.GENOTYPE → 부모의 모든 비트가 자식에 포함된 경우만 TRUE
-- 부모 정보 가져오기: 자기 테이블을 **Self Join** 해서 자식.PARENT_ID = 부모.ID로 연결
-- 출력값: 자식 ID, 자식 GENOTYPE, 부모 GENOTYPE
-- 정렬: ID 오름차순

## 문제 푼 순서
-- 1) 자식과 부모 정보를 함께 보기 위해 자기 자신 테이블 조인
FROM ecoli_data AS E
JOIN ecoli_data AS P
  ON E.parent_id = P.id

-- 2) 부모의 형질이 자식에 모두 포함되었는지 검사 (비트마스크 조건)
WHERE E.genotype & P.genotype = P.genotype

-- 3) 필요한 컬럼만 출력
SELECT 
    E.id,                  -- 자식 ID
    E.genotype,            -- 자식 형질
    P.genotype AS parent_genotype  -- 부모 형질

-- 4) 결과는 ID 오름차순으로 정렬
ORDER BY E.id ASC;

## 작성한 최종 쿼리
select 
    E.ID, 
    E.GENOTYPE, 
    P.genotype as PARENT_GENOTYPE
from ecoli_data E
join ecoli_data P on E.parent_id = P.id         ## 자기 테이블 조인
where E.genotype & P.genotype = P.genotype
order by ID asc;
