# 제목이 모음으로 끝나지 않는 영화
## 🧠 해결 전략

1. `rating` 컬럼 기반
    1. 17세 미만 관람 가능 등급: G, PG, PG-13
    2. 17세 미만 관람 불가능 등급: R, NC-17
    - 17세 미만 관람 불가능 등급을 만족하는 값들을 검색하기 위해 `IN` 사용
2. `title` 이 모음으로 끝나지 않기
    - 제목 끝글자를 확인하기 위해 `LIKE` 사용
    - 끝글자가 모음이 아닌 값들을 검색하기 위해 `NOT` 사용
3. 코드 개선
    - 제목 끝글자 확인하기 위해 `RIGHT()` 사용
    - 끝글자가 모음으로 되어 있지 않는 값들을 검색하기 위해 `NOT IN` 사용

## 🧾 SQL 풀이

```sql
SELECT 
  title
FROM film
WHERE rating IN ("R", "NC-17")
  AND title NOT like '%A'
  AND title NOT like '%E'
  AND title NOT like '%I'
  AND title NOT like '%O'
  AND title NOT like '%U'

-- 코드 개선
SELECT
  title
FROM film
WHERE rating IN ("R", "NC-17")
  AND RIGHT(title, 1) NOT IN ("A", "E", "I", "O", "U")
```

## ✅ 개념 정리

1. 문자열 일부분 가져오기
    1. `LEFT(문자, 가져올 개수)` : 문자열 왼쪽을 기준으로 일정 개수를 가져오는 함수
    2. `MID(문자, 시작 위치, 가져올 개수)` : 문자에 지정한 시작 위치를 기준으로 일정 개수를 가져오는 함수
        1. `SUBSTR`, `SUBSTRING` 함수의 동의어
    3. `RIGHT(문자, 가져올 개수)` : 문자열 오른쪽을 기준으로 일정 개수를 가져오는 함수
    
    ```sql
    SELECT LEFT('abcdefg', 3);
    -- 결과: abc
    
    SELECT MID('abcdefg', 2, 4);
    -- SELECT SUBSTR('abcdefg', 2, 4);
    -- SELECT SUBSTRING('abcdefg', 2, 4);
    -- 결과: bcde
    
    SELECT RIGHT('abcdefg', 3);
    -- 결과: efg
    ```
