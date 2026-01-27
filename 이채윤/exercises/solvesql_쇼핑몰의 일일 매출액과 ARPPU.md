# 쇼핑몰의 일일 매출액과 ARPPU
## 🧠 해결 전략

1. `JOIN` 을 사용하여 `payment_value` 매칭
2. 일별 집계를 위해 `DATE()`와 `GROUP BY`를 사용
3. `HAVING` 을 사용하여 2018년 1월 1일 이후인 것만 추출
4. `COUNT(DISTINCT )`로 일별 고객 수를 구하고, `SUM()` 으로 일별 매출액 합산
5. 4번에서 구한 일별 고객 수와 일별 매출액으로 ARPPU를 산출
6. `ORDER BY` 로 정렬

## 🧾 SQL 풀이

```sql
SELECT
  -- ood.*
  DATE(ood.order_purchase_timestamp) AS dt
  ,COUNT(DISTINCT ood.customer_id) AS pu
  ,ROUND(SUM(oop.payment_value), 2) AS revenue_daily
  ,ROUND(SUM(oop.payment_value)/COUNT(DISTINCT ood.customer_id), 2) AS arppu
FROM olist_orders_dataset ood
JOIN olist_order_payments_dataset oop ON ood.order_id = oop.order_id
GROUP BY DATE(ood.order_purchase_timestamp)
HAVING dt >= "2018-01-01"
ORDER BY dt
```

## ✅ 개념 정리

1. HAVING에서 alias 사용 이유
    1. SQL 논리적 실행 순서는 아래와 같음
        
        ```sql
        FROM >> JOIN >> WHERE >> GROUP BY >> HAVING >> SELECT >> ORDER BY
        ```
        
    2. 위 기준만 보면 SELECT에서 정의된 alias를 HAVING 실행 단계에서는 alias를 몰라야 하지 않나?
        1. HAVING은 그룹 결과를 필터링하는 단계
        2. GROUP BY 에서 집계 기준 표현식이 확정되어 있음
        3. alia는 새로운 값이 아니라 그 표현식의 이름임
        4. 따라서 alias를 참조 이름으로 허용!
    3. 즉, HAVING은 SELECT alias를 “계산 결과”로 쓰는 게 아니라 이미 계산된 GROUP BY 표현식을 “참조 이름”으로 쓰는 것.
