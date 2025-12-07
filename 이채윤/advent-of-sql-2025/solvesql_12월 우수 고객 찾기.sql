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
