# 스테디셀러 작가 찾기
## 🧠 해결 전략
1. `fict_tbl`
    1. 조건: `genre`가 `Fiction`인 책 목록
    2. `author`, `year`, 작가별 총 등재 건수(`pub_cnt`)를 추출
        1. 작가별 총 등재 건수(`pub_cnt`)는 `윈도우 함수`를 사용하여 집계
        2. 모든 컬럼에서 중복이 있을 수 있으므로 `DISTINCT` 로 중복 제거\
2. `seq_tbl` 
    1. 작가별 총 등재 건수가 5건 이상인 경우만 필터링
        1. 이유: 5년 이상이니까 등재 건수도 5건 이상이어야 함
    2. 한 작가의 등재 연도가 연속인지 확인 필요
    3. 연속의 기준은?
        1. 현재 연도가 지난 연도와 1 차이가 날 때, 연속으로 판단함.
    4. `윈도우 함수` 를 사용하여 지난 연도를 가져오기
        1. `LAG(year) OVER(PARTITION BY author ORDER BY year)`
    5. `CASE WHEN`을 사용하여 현재 연도와 지난 연도 차이값으로 연속 유무(`seq_yn`) 판단
        1. 차이가 1이면 → 1
        2. 차이가 1이 아니면 → 0
3. `rn_seq_tbl`
    1. `윈도우 함수`를 사용하여 연속 연도 합(`seq_sum`), 작가별 연도 순서(내림차순)(`rn_desc`) 산출
        1. `seq_sum` : `SUM(seq_yn) OVER(PARTITION BY author)`
        2. `rn_desc` : `ROW_NUMBER() OVER(PARTITION BY author ORDER BY year DESC)`
4. 최종 조건
    1. 가장 최근 연도의 행 추출 → `rn_desc=1`  
    2. 연속 베스트셀러 년수가 5년 이상 → `seq_sum + 1 >= 5` 

## 🧾 SQL 풀이
```sql
WITH fict_tbl AS (
  SELECT
    DISTINCT
    author
    ,year
    ,COUNT(name) OVER(PARTITION BY author) AS pub_cnt
  FROM books
  WHERE genre = "Fiction"
), seq_tbl AS (
  SELECT
    *
    ,CASE WHEN 
      year - LAG(year) OVER(PARTITION BY author ORDER BY year) = 1 THEN 1 ELSE 0 END AS seq_yn
  FROM fict_tbl
  WHERE pub_cnt >= 5
), rn_seq_tbl AS (
  SELECT
    *
    ,SUM(seq_yn) OVER(PARTITION BY author) AS seq_sum
    ,ROW_NUMBER() OVER(PARTITION BY author ORDER BY year DESC) AS rn_desc
  FROM seq_tbl
)
SELECT
  author
  ,year
  ,seq_sum + 1 AS depth
FROM rn_seq_tbl
WHERE rn_desc = 1
  AND seq_sum + 1 >= 5
```

## ✅ 개념 정리

1. `DISTINCT` : **SELECT 절에 나열된 모든 컬럼의 조합(row 전체)**을 하나의 단위로 보고 중복을 제거
    1. 함수가 아님 → 즉, 내가 원하는 컬럼에만 적용하는 것은 불가능
    2. `DISTINCT` 뒤에 여러 개의 컬럼이 붙는다면
        1. 개별 컬럼들에 적용되는 것이 아님
        2. **중복되는 조합 중 하나만 출력하는 것**
    3. [참고 자료](https://blog.naver.com/PostView.nhn?blogId=owl6615&logNo=222193523575)
2. [공식 문제 풀이](https://www.youtube.com/watch?v=S930HXU3Sdk)
