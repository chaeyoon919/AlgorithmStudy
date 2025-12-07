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

-- -- [풀이] - 오답
-- select 
--     species
--     ,body_mass_g
-- from penguins
-- where species is not null or body_mass_g is not null
-- order by body_mass_g desc, species ASC;


-- [개념 정리]
-- - species가 없는 경우 제외
-- - body_mass_g가 없는 경우 제외
-- : species와 body_mass_g가 모두 있는 경우만 추출하면 됨. 따라서 OR가 아닌 AND.
