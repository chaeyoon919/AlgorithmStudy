-- [문제]
-- Palmer Penguins 데이터베이스는 남극 Palmer Archipelago 지역에 서식 중인 펭귄의 종, 서식지, 신체 특징 정보가 들어있습니다.

-- 펭귄의 종과 펭귄의 몸무게의 관계에 대해서 알아보기 위해 기초 데이터를 추출하려고 합니다. penguins 테이블에서 펭귄의 종, 몸무게 정보가 담긴 열을 출력하는 쿼리를 작성해주세요. 펭귄의 종 또는 몸무게 데이터가 없는 개체는 쿼리 결과에서 제외해주세요.

-- 결과는 펭귄의 몸무게가 무거운 순서대로 정렬하고, 만약 몸무게가 같다면 펭귄의 종 이름으로 오름차순 정렬해주세요. 쿼리 결과에는 아래 컬럼이 포함되어 있어야 합니다.

-- species: 펭귄의 종
-- body_mass_g: 펭귄의 몸무게(g)

-- [해결 방법]
-- - 조건: 펭귄의 종 or 펭귄의 몸무게가 없는 개체는 결과에서 제외
-- - 추출 스키마: 펭귄의 종(species), 펭귄의 몸무게(body_mass_g)
-- - 정렬: 펭귄의 몸무게가 무거운 순서(=내림차순), 펭귄의 종 이름(오름차순)

-- [풀이]
SELECT
    species
    ,body_mass_g
FROM penguins
WHERE species IS NOT NULL AND body_mass_g IS NOT NULL
ORDER BY body_mass_g DESC, species ASC;

-- [풀이] - 오답
select 
    species
    ,body_mass_g
from penguins
where species is not null or body_mass_g is not null
order by body_mass_g desc, species ASC;


-- [개념 정리]
-- - species가 없는 경우 제외
-- - body_mass_g가 없는 경우 제외
-- : species와 body_mass_g가 모두 있는 경우만 추출하면 됨. 따라서 OR가 아닌 AND.
