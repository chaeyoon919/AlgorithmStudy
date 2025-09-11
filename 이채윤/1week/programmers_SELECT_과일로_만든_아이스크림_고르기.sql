-- 문제 접근
-- table: FIRST_HALF(기본키: FLAVOR), ICECREAM_INFO(FIRST_HALF 테이블의 FLAVOR의 외래 키)
	-- 테이블의 기본키와 외래키
	-- 기본키: PK, 메인으로 선정되는 키, 유일성과 최소성을 가짐, 레코드를 식별할 때 기준이 되는 반드시 필요한 키
	-- 외래키: 테이블간의 관계를 나타낼 때 사용, 다른 테이블의 기본키를 참조해 사용(한 테이블의 외래키는 연결되어 있는 다른 테이블의 기본키 중 하나)
	-- 참고자료: https://velog.io/@kon6443/DB-%EA%B8%B0%EB%B3%B8%ED%82%A4-%EC%99%B8%EB%9E%98%ED%82%A4-%ED%9B%84%EB%B3%B4%ED%82%A4-%EB%B3%B5%ED%95%A9%ED%82%A4-%EA%B0%9C%EB%85%90-4x1bgz5w
-- 조건1: 총 주문량(total_order) > 3000 이고, 아이스크림 주성분(ingreditent_type) = '과일=fruit_based'
-- 조건2: 총주문량 내림차순 정렬 


SELECT fh.flavor
FROM first_half fh
JOIN icecream_info ii ON fh.flavor = ii.flavor
WHERE fh.total_order > 3000 AND ii.ingredient_type = 'fruit_based'
ORDER BY fh.total_order DESC;
