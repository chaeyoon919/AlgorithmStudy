## 🧠 해결 전략
1. `CASE WHEN` 조건문을 이용하여 조건별 스탬프 계산  
2. 계산된 스탬프 값을 기준으로 `GROUP BY`  
3. `ORDER BY stamp ASC` 수행  


## 🧾 SQL 풀이
```sql
SELECT
    stamp
    ,COUNT(*) AS count_bill
FROM (
    SELECT
        *
        ,CASE
            WHEN total_bill >= 25 THEN 2
            WHEN total_bill >= 15 AND total_bill < 25 THEN 1
            ELSE 0 
        END AS stamp
    FROM tips
    ) AS past
    GROUP BY stamp
    ORDER BY stamp ASC;
```


## ✅ 개념 정리
- CASE WHEN 문법
```sql
CASE
    WHEN 조건1 THEN 값1
    WHEN 조건2 THEN 값2
    ELSE 기본값
END 
```
