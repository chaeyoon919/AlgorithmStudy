# 기증품 비율 계산하기
## 🧠 해결 전략

1. 기증품의 개수 세기
    1. 조건에 따라 `LIKE`를 사용하여 gift가 들어간 row만 추출 후 `COUNT(*)`
2. 계산한 기중품 수량을 `서브 쿼리` 로 두고, 전체 수량과의 백분율 계산
- 틀린 코드 회고
    - 백분율로 계산하지 않음 → 문제를 잘 읽자!
    
    ```sql
    SELECT 
      ROUND(
        (SELECT
          COUNT(*) AS gift_cnt
        FROM artworks
        WHERE LOWER(credit) LIKE '%gift%')/COUNT(*),
      3) AS ratio
    FROM artworks
    ```
    

## 🧾 SQL 풀이

```sql
SELECT 
  -- COUNT(*)
  -- ,(SELECT
  --     COUNT(*) AS gift_cnt
  --   FROM artworks
  --   WHERE LOWER(credit) LIKE '%gift%')
  -- ,
  ROUND(
    ((SELECT
      COUNT(*) AS gift_cnt
    FROM artworks
    WHERE LOWER(credit) LIKE '%gift%')/COUNT(*))*100,
  3) AS ratio
FROM artworks
```

- 쿼리 개선
    - 같은 테이블을 2번 읽지 않고, 1번 스캔
    
    ```sql
    SELECT
    	ROUND(
    		SUM(CASE WHEN LOWER(credit) LIKE '%gift%' THEN 1 ELSE 0 END)
    		/COUNT(*) * 100,
    		3) AS ratio
    FROM artworks
    ```
    

## ✅ 개념 정리

1. 서브쿼리 위치
    
    
    | **위치** | **예시** |
    | --- | --- |
    | SELECT | SELECT (SELECT COUNT(*)) |
    | FROM | FROM (SELECT ...) t |
    | WHERE | WHERE x IN (SELECT ...) |
    | HAVING | HAVING COUNT(*) > (SELECT AVG(...)) |
