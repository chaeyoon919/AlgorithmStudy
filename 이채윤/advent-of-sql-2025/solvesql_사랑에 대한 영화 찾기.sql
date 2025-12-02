    -- [문제]
    -- Movies on OTT 데이터베이스는 넷플릭스, 디즈니 플러스 등 OTT 플랫폼에서 서비스하는 영화 정보를 담고 있습니다.

    -- 이 영화 중 크리스마스에 연인과 함께 볼 사랑에 대한 영화를 찾고 싶습니다. 영화 제목에 'Love' 또는 'love'라는 글자가 포함된 영화의 제목과 개봉 연도, 로튼 토마토 평점을 조회하는 쿼리를 작성해주세요. 결과는 로튼 토마토 평점이 높은 순으로 정렬되어 있어야 하고, 만약 평점이 같다면 개봉 연도가 최근인 영화부터 출력되어야 합니다.

    -- title: 영화 제목
    -- year: 개봉 연도
    -- rotten_tomatoes: 로튼 토마토 평점

    -- [해결 방법]
    --     - 조건: 영화의 제목에 'Love', 'love' 글자 포함
    --     - 추출 스키마: 영화 제목(title), 개봉 연도(year), 평점(rotten_tomatoes)
    --     - 정렬: 평점(rotten_tomatoes) 높은 순, 개봉 연도(year) 최근 순

    -- [풀이]
    SELECT 
    title
    ,year
    ,rotten_tomatoes
    FROM movies
    WHERE LOWER(title) LIKE '%love%'
    ORDER BY rotten_tomatoes DESC, year DESC;
    ;

    -- [개념 정리]
    -- LIKE: 
