# 두 대회 연속으로 출전한 기록이 있는 배구 선수
## 🧠 해결 전략
1. 문제에서 제시한 조건을 `WITH (CTE 문)`을 사용하여 임시 저장
2. `ROW_NUMBER() OVER (PARTITION BY ~)`를 사용하여, 선수별 일련번호 부여
    (year 기준 정렬)
3. 한 선수가 연속으로 올림픽에 참여했는지 확인하기 위해, `athlete_id` 기준으로 조인
    3-1. 이 때, 올림픽은 4년마다 열리니까, n+1번째 출전 연도가 n번째 출전 연도보다 4 보다 큰 값만


## 🧾 SQL 풀이
```sql
WITH olympic AS (SELECT
  records.*
  ,games.year
  -- ,games.season
  -- ,games.city
  ,teams.team
  ,events.event
  ,athletes.name
  ,ROW_NUMBER() OVER (PARTITION BY athlete_id ORDER BY year) AS rn
FROM records
JOIN games ON games.ID = records.game_id
JOIN teams ON teams.ID = records.team_id
JOIN events ON events.ID = records.event_id
JOIN athletes ON athletes.ID = records.athlete_id
WHERE team = "KOR" AND event = "Volleyball Women's Volleyball")
SELECT DISTINCT
  o1.athlete_id AS id
  ,o1.name
FROM olympic o1
JOIN olympic o2 ON o1.athlete_id = o2.athlete_id
  AND o2.rn = o1.rn + 1
  AND o2.year = o1.year + 4
```


## ✅ 개념 정리
1. ROW_NUMBER()
    - 결과 집합의 파티션 내 각 행에 순차적인 정수를 할당하는 윈도우 함수
    - 특징
        - 행의 번호는 각 파티션에 대해 1번부터 할당
        - 정렬의 중복 값이 있어도 서로 다른 정수를 할당
    - SYNTAX
    ```sql
    ROW_NUMBER() OVER (
    [PARTITION BY partition_expression, ... ]
    ORDER BY sort_expression [ASC | DESC], ...
    )   
    ```
    - [참고 자료1](https://developjuns.tistory.com/42 "[MSSQL] 윈도우 함수 ROW_NUMBER() 순차번호 할당")
    - [참고 자료2](https://schatz37.tistory.com/12#head6 "[SQL] 윈도우 함수(Window Function)의 소중함을 느껴보자")
2. 셀프 조인
    - 같은 대상의 두 상태를 맞붙여서 비교하는 것
    - 셀프 조인이 필요한 상황
        - 같은 테이블 안에서 행을 서로 비교해야 하는 상황
        - 같은 개체 안에서 값이 어떻게 변했는지 알고 싶을 때
        - 순서가 있는 데이터에서 이전/다음 행과 비교할 때
    - 같은 개체를 지정하는 ID로 조인 → 비교하고 싶은 두 순간의 관계를 조건으로 추가
    - [참고 자료1](https://minor-research.tistory.com/24 "sql 셀프조인(self join) 쿼리 쓰는 이유와 간단한 예제")
