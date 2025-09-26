# 음식종류별로 즐겨찾기가 가장 많은 식당의 상세 정보 구하기
## point: GROUP BY 컬럼 외 다른 컬럼도 같이 출력해야 하는 경우
## 음식종류별 즐겨찾기 수가 가장 많은 식당
## 출력: FOOD_TYPE REST_ID REST_NAME FAVORITES
  
## 1. 서브쿼리 ver.
SELECT I.FOOD_TYPE, I.REST_ID, I.REST_NAME, I.FAVORITES
FROM REST_INFO I
JOIN (SELECT FOOD_TYPE, MAX(FAVORITES) AS MAX_FAV
        FROM REST_INFO
        GROUP BY FOOD_TYPE) AS A 
    ON I.FAVORITES = A.MAX_FAV AND I.FOOD_TYPE = A.FOOD_TYPE    -- 같은 food_type 카테고리이면서 그 카테고리의 최대 즐겨찾기 값을 가진 행만 매칭
ORDER BY I.FOOD_TYPE DESC;

## 2. 윈도우 함수+CTE ver.
WITH HIGHEST AS (      -- food_type 별로 favorites 내림차순으로 매긴 rank 포함한 CTE 명명 
    SELECT 
        *,
        RANK() OVER (PARTITION BY FOOD_TYPE ORDER BY FAVORITES DESC) AS RK    -- food_type 별로 favorites 내림차순 rank 매기기
    FROM REST_INFO
)
SELECT FOOD_TYPE, REST_ID, REST_NAME, FAVORITES
FROM HIGHEST
WHERE RK = 1  -- 즐겨찾기가 가장 많은 REST(레스토랑)만 필터링
ORDER BY 1 DESC;
