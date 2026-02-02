# 전력 소비량 이동 평균 구하기
## 🎯 요구 사항

- 조건: 2017년 1월 1일 0시부터 2017년 2월 1일 0시까지 10분 단위로 3개 발전소 전력 소비량의 1시간 범위 단순 이동 평균을 계산
    - 전력 소비량 측정은 매 10분마다 시작해 10분간 진행하는 방식이고, `measured_at` 컬럼에 측정 시작 시각이 기록됨
    - 이동 평균 값은 소수점 셋째 자리에서 반올림 해 둘째 자리까지 표시
- 추출 스키마:
    - `end_at`: 이동 평균 범위의 끝 시각
    - `zone_quads`: Quads 지역 전력 소비량의 1시간 단순 이동 평균
    - `zone_smir`: Smir 지역 전력 소비량의 1시간 단순 이동 평균
    - `zone_boussafou`: Boussafou 지역 전력 소비량의 1시간 단순 이동 평균
- 정렬: X

## 🧠 해결 전략

1. `WHERE` 을 사용하여 2017년 1월 1일 0시부터 2017년 2월 1일 0시 이전까지의 데이터만 추출
    1. 전력 소비량 측정은 매 10분마다 시작해 10분간 진행되는 방식 → 끝 시각은 항상 측정 시작 시간의 +10분
2. `SELECT` 절에서
    1. 끝 시각(`end_at`): `DATE_ADD()` 를 이용하여 측정 시작 시각 + 10분 계산
    2. `윈도우 함수` 를 사용하여 현재 행 기준 1시간 범위 행들만 평균을 계산
        1. 현재 행 기준 1시간 범위 행 ⇒ 현재 행(10분)과 현재 행 기준 이전 5개 행들(50분)

## 🧾 SQL 풀이

```sql
SELECT
  -- measured_at
  -- ,LEAD(measured_at) OVER(ORDER BY measured_at) AS end_at
  DATE_ADD(measured_at, INTERVAL 10 MINUTE) AS end_at
  -- ,zone_quads
  -- ,zone_smir
  -- ,zone_boussafou
  ,ROUND(AVG(zone_quads) OVER(ORDER BY measured_at ROWS BETWEEN 5 PRECEDING AND CURRENT ROW), 2) AS zone_quads
  ,ROUND(AVG(zone_smir) OVER(ORDER BY measured_at ROWS BETWEEN 5 PRECEDING AND CURRENT ROW), 2) AS zone_smir
  ,ROUND(AVG(zone_boussafou) OVER(ORDER BY measured_at ROWS BETWEEN 5 PRECEDING AND CURRENT ROW), 2) AS zone_boussafou
FROM power_consumptions
WHERE measured_at >= "2017-01-01 00:00:00"
  AND measured_at < "2017-02-01 00:00:00"
```

## ✅ 개념 정리

1.
