# 🧠 해결 전략
1. `GROUP BY`와 `HAVING`을 이용하여 대여 횟수 35회 이상 고객 추출
2. 두 테이블 `JOIN`
3. `조건문`으로 유효 고객을 추출


## 🧾 SQL 풀이
```sql
WITH excellent_cus AS (
  SELECT 
    customer_id,
    COUNT(rental_id)
  FROM rental
  GROUP BY customer_id
  HAVING COUNT(rental_id) >= 35
)
SELECT c.customer_id
FROM excellent_cus AS e_cus
JOIN customer c ON e_cus.customer_id = c.customer_id
WHERE c.active = 1
```


## ✅ 개념 정리
1. JOIN: 두 테이블을 공통 키 기반으로 연결하는 연산
    ```
    SELECT ...
    FROM A
    JOIN B
    ON A.key = B.key;
    ```

2. HAVING: GROUP BY 이후 만들어진 집계 결과를 핕터링 하는 절
    - WHERE: 개별 행(row)를 대상으로 조건
    - HAVING: 그룹화된 결과(group)에 조건

3. CTE(WITH 절):쿼리 안에서 잠시 존재하는 가상 테이블을 만드는 기능(한 번 만들어놓고, 아래에서 자유롭게 재사용 가능한 임시 테이블)
    - 복잡한 로직을 작은 조각으로 분할 가능
    - 재사용 가능(같은 CTE를 여러 번 조인 가능)
    - 쿼리 가독성 향상 및 유지보수 용이
    ```
    WITH temp AS (
        SELECT ...
        FROM ...
    )
    SELECT *
    FROM temp;
    ```
