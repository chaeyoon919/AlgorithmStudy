-- -- 사전 지식
	-- 분화를 시작한 개체: 부모 개체
	-- 분화가 되어 나온 개체: 자식 개체

-- -- 테이블
	--  ECOLI_DATA: ID, PARENT_ID, SIZE_OF_COLONY, DIFFERENTIATION_DATE, GENOTYPE (대장균 개체의 ID, 부모 개체의 ID, 개체의 크기, 분화되어 나온 날짜, 개체의 형질)
	--  최초의 대장균 개체의 PARENT_ID = NULL

-- -- 조건
	-- 부모의 형질을 모두 보유한 ID, GENOTYPE, PARENT_GENOTYPE을 출력
	-- ID에 대해 오름차순 정렬

-- -- 작성 코드
SELECT
    	p.ID
	,p.GENOTYPE
	,c.GENOTYPE AS PARENT_GENOTYPE
FROM ECOLI_DATA p
-- self join: 같은 테이블을 자기 자신과 조인( 부모와 자식의 정보 비교)
JOIN ECOLI_DATA c ON p.PARENT_ID = c.ID
-- 형질비교
--  부모의 형질이 모두 자식에게 있는지 확인하려면 자식 & 부모 == 부모
--  : 자식의 GENOTYPE 안에 부모의 1인 자릿수가 모두 포함되어야 함
--  &: 비트 AND 연산자
--  https://k-wien1589.tistory.com/122
WHERE p.GENOTYPE & c.GENOTYPE = c.GENOTYPE
ORDER BY p.ID
;
