## 가장 최근에 들어온 동물 조회
## 문제 요약
- `ANIMAL_INS` 테이블에는 동물 보호소에 들어온 동물의 정보가 담겨 있습니다.  
- 주요 컬럼:
  - `ANIMAL_ID`: 동물 ID
  - `ANIMAL_TYPE`: 생물 종
  - `DATETIME`: 보호 시작일
  - `INTAKE_CONDITION`: 입소 당시 상태
  - `NAME`: 이름
  - `SEX_UPON_INTAKE`: 성별 및 중성화 여부

## 요구사항
- 보호소에 들어온 동물 중 **가장 최근에 들어온 동물의 입소 시간**을 조회합니다.
- 출력 컬럼명은 자유롭게 지정 가능합니다.

## 예시
| ANIMAL_ID | ANIMAL_TYPE | DATETIME           | INTAKE_CONDITION | NAME     | SEX_UPON_INTAKE |
|-----------|-------------|--------------------|------------------|----------|-----------------|
| A399552   | Dog         | 2013-10-14 15:38:00| Normal           | Jack     | Neutered Male   |
| A379998   | Dog         | 2013-10-23 11:42:00| Normal           | Disciple | Intact Male     |
| A370852   | Dog         | 2013-11-03 15:04:00| Normal           | Katie    | Spayed Female   |
| A403564   | Dog         | 2013-11-18 17:03:00| Normal           | Anna     | Spayed Female   |

- 가장 늦게 들어온 동물: **Anna**  
- 입소 시간: **2013-11-18 17:03:00**

## 답1. 가장 단순하고 빠름 --Good
SELECT MAX(DATETIME)
FROM ANIMAL_INS

## 답2. 확장성과 범용적 측면에선 용이하지만 효율성 떨어짐 --Not Good
WITH LATEST AS (               -- 검증 쿼리 겸 직관성 확보 위해 별도의 테이블 구성(CTE 생성)
    SELECT
        ANIMAL_ID, NAME, DATETIME,
        ROW_NUMBER() OVER (ORDER BY DATETIME DESC) AS RN_TIME    -- DATETIME 내림차순으로 행넘버
    FROM ANIMAL_INS I
)
SELECT DATETIME
FROM LATEST
WHERE RN_TIME = 1;
