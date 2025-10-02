# 동물의 생물 종, 이름, 성별 및 중성화 여부를 아이디 순으로 조회하기
## 이름이 없는 동물의 이름은 "No name"으로 표시
## ANIMAL_TYPE, NAME, SEX_UPON_INTAKE
SELECT
    ANIMAL_TYPE,
    CASE WHEN
        NAME IS NULL THEN 'No name'   -- NAME이 NULL인 경우 'No name'으로 표시
        ELSE NAME                     -- 그 외에는 그대로 NAME
    END AS NAME,
    SEX_UPON_INTAKE
FROM ANIMAL_INS
ORDER BY ANIMAL_ID;
