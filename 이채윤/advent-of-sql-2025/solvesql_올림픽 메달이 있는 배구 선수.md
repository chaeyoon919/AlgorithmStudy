# 올림픽 메달이 있는 배구 선수
## 🧠 해결 전략
1. `GROUP_CONCAT`을 사용하여 선수 그룹 내부에 있는 메달 정보를 쉼표(,)로 구분된 하나의 문자열로 만듬


## 🧾 SQL 풀이
- 정답
```sql
SELECT a.id
     ,a.name
     ,GROUP_CONCAT(r.medal SEPARATOR ',') AS medals
FROM records r
JOIN events e ON r.event_id = e.id
JOIN teams t ON r.team_id = t.id
JOIN athletes a ON r.athlete_id = a.id
WHERE 1=1
  AND e.event = 'Volleyball Women''s Volleyball'
  AND t.team = 'KOR'
  AND r.medal is not null
GROUP BY a.id
```

## ✅ 개념 정리
1. GROUP_CONCAT()
    - MySQL에서 제공되는 문자열 집계 함수(Aggregation Function)
    - 여러 행의 값을 하나의 문자열로 이어붙여서 반환하는 함수
    - SYNTAX
        ```
        GROUP_CONCAT(column ORDER BY column DESC SEPARATOR 원하는 구분자)
        ```
    - 특징
        - NULL 무시됨(NULL이 포함되면 건너뛰고 붙임)
    - Q&A
        - GROUP BY를 하면 행이 축약되는데, 왜 축약된 그룹 안의 value들이 GROUP_COUNT()에서 모두 나타나는가?
            - a. GROUP BY: "행을 묶음"
            - b. GROUP_CONCAT(): "묶인 행 전체를 다시 참조하는 집계 함수"
            - c. 즉, 행은 합쳐지지만 집계 함수는 "합쳐지기 전에 존재했던 원본 행 전체"를 기반으로 계산됨(묶인 그룹 내부의 행에 직접 접근)
            - d. 정리: 같은 key(name)에 속한 모든 행을 하나의 그룹 객체로 묶는 것 → 집계 함수가 그 그룹 내부의 행 전체를 참조하는 것
2. SQL 실행 순서
    - (데이터 준비 단계)
    ```text
        1. FROM           -- 첫 테이블
            - 테이블 선택 및 스캔
            - DB는 먼저 어떤 테이블을 읽을지 결정함
            - 인덱스 접근 전략 등을 여기서 준비
        2. JOIN           -- 다른 테이블과 연결
            - 모든 JOIN 대상 테이블이 FROM 단계에서 이미 준비됨
            - 조인할 준비
        3. ON             -- 조인 조건 적용
            - JOIN 할 때, 어떤 행끼리 연결할지 결정하는 단계
        4. WHERE          -- 행 단위 필터링
            - GROUP BY 이전에 실행되기 때문에, 집계 함수(SUM, AVG 등)을 사용할 수 없음
        ----------------------------------
        - (그룹 및 집계 단계)
        5. GROUP BY       -- 그룹 묶기
            - 남은 행들을 묶어서 그룹을 만듬
            - 여기서 테이블 모양이 달라짐
                - 그룹 하나당 "하나의 행"이 됨
                - 이후 SELECT에서는 집계된 값만 접근 가능
        6. HAVING         -- 그룹 대상 필터링
            - WHERE와 달리, 그룹핑된 결과를 대상으로 조건 걸 수 있음
        ----------------------------------
        - (출력 단계)
        7. SELECT         -- 컬럼 선택 & 계산
            - 최종 표현식 계산
                - SELECT문에 있는 컬럼
                - 집계 함수(SUM, AVG 등)
                - 윈도우 함수(LAG, ROW_NUMBER 등)
        8. DISTINCT       -- 중복 제거
        9. ORDER BY       -- 정렬
            - SELECT alias를 자유롭게 사용 가능
        10. LIMIT         -- 결과 제한
    ```
    - Q&A
        - SELECT alias를 WHERE에서 못 쓰는데, ORDER BY에서는 가능한 이유
            - a. WHERE가 SELECT보다 먼저 실행되기 떄문
        - WHERE에서 집계 함수를 못 쓰는 이유
            - a. WHERE는 GROUP BY 이전에 실행되기 때문
        - GROUP BY 이후에 SELECT가 어떤 컬럼을 허용하는가?
            - a. 두 종류의 컬럼만 허용됨
                - GROUP BY에 포함된 컬럼
                - 집계 함수로 계산된 컬럼(SUM, AVG, COUNT 등)
        - 윈도우 함수가 SELECT에서 잘 작동하는 이유
            - a. 윈도우 함수는 "행을 그대로 유지한 채" 그룹 통게만 계산해 붙이기 때문이고, 계산 시점은 SELECT 단계임
        - WHERE vs. HAVING
            - 아래 표 참고
                |WHERE|HAVING|
                |------|-----|
                |그룹핑 전에 실행|그룹핑 후에 실행|
                |개별 행 단위 필터링|그룹 단위 필터링|
                |집계 함수 사용 불가|집계 함수 사용 가능|
                |SELECT alias 사용 불가|SELECT alias 사용 가능|
                
