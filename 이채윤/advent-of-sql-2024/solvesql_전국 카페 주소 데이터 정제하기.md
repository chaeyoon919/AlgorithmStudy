# 전국 카페 주소 데이터 정제하기
## 🧠 해결 전략

1. `SUBSTRING_INDEX()`를 사용하여 `address` 의 띄어쓰기 기준 *시, 도 정보*  및 *시, 군, 구 정보*를 가져오기
2. `GROUP BY` 를 사용하여 행정구역(`sido`,  `sigungu`)별로 카페 개수 집계

## 🧾 SQL 풀이

```sql

SELECT
  sido
  ,sigungu
  ,COUNT(cafe_id) AS cnt
FROM(
SELECT
  *
  ,SUBSTRING_INDEX(address, " ", 1) AS sido
  ,SUBSTRING_INDEX(SUBSTRING_INDEX(address, " ", 2), " ", -1) AS sigungu
FROM cafes) prep_cafes
GROUP BY sido, sigungu
ORDER BY cnt DESC

```

## ✅ 개념 정리

1. `SUBSTRING_INDEX()`
    
    : 특정 구분자를 기준으로 분리하여 부분 문자열을 추출
    
    ```sql
    SUBSTRING_INDEX(str, delimiter, count)
    ```
    
    - str : 추출하고자 하는 원본 문자열
    - delimiter : 문자열을 분리할 구분자
    - count : 구분자를 기분으로 몇 번째까지 추출할지 나타내는 숫자
        - 양수인 경우 : 왼 -> 오
        - 음수인 경우 : 오 -> 왼
    
    ```sql
    SELECT SUBSTRING_INDEX("apple,banana,cherry,orange", ",", 2);
    -- 결과: "apple,banana"
    
    SELECT SUBSTRING_INDEX("apple,banana,cherry,orange", ",", -2);
    -- 결과: "cherry,orange"
    ```
