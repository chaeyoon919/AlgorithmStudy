-- [문제] 
-- US E-Commerce Records 2020 데이터베이스에는 2020년 1년 동안 미국의 한 커머스 업체의 주문 정보가 저장되어 있습니다.

-- 12월 판매 실적을 개선하기 위해 지난 12월에 매출이 높았던 고객들에게 프로모션을 제공하려고 합니다. 2020년 12월 동안 있었던 모든 주문의 매출 합계가 1000$ 이상인 고객 ID를 출력하는 쿼리를 작성해주세요. 쿼리 결과에는 고객 ID가 들어있는 컬럼 하나만 있어야 합니다.

-- [해결 방법]
-- - 조건: 2020년 12월, 매출 합계가 1000$ 이상
-- - 추출 스키마: 고객 ID
-- - 정렬:

-- [풀이]
SELECT
    customer_id
FROM records
WHERE order_date >= '2020-12-01' AND order_date < '2021-01-01'
GROUP BY customer_id
HAVING SUM(sales) >= 1000
;

-- -- [풀이] - 오답
-- select customer_id
-- from records
-- where 1=1
-- AND order_date BETWEEN "2020-12-01" AND "2020-12-31"
-- AND sales >= 1000

-- [개념 정리]
