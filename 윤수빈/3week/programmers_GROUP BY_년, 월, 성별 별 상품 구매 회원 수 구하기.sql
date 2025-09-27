## 연, 월, 성별 별로 상품을 구매한 회원 수
## 성별이 NULL인 경우 제외
SELECT 
    YEAR(O.SALES_DATE) AS YEAR,
    MONTH(O.SALES_DATE) AS MONTH,
    U.GENDER,
    COUNT(DISTINCT U.USER_ID) AS USERS    -- 상품을 구매한 "회원 수" -> 중복이 있으므로 distinct하게 count
FROM USER_INFO U
JOIN ONLINE_SALE O ON U.USER_ID = O.USER_ID    -- user_id로 inner join
WHERE U.GENDER IS NOT NULL      -- 성별 정보가 없는 경우 결과에서 제외
GROUP BY YEAR(O.SALES_DATE), MONTH(O.SALES_DATE), U.GENDER      -- 년, 월, 성별 별로 그룹핑
ORDER BY 1,2,3;     -- 년, 월, 성별을 기준으로 오름차순 정렬(빠른 출력을 위해 넘버로 지칭)
