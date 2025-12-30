### 문제 요약
- 테이블: `FISH_INFO`
- 조건:
  - 잡은 물고기의 길이(`LENGTH`)가 10cm 이하일 경우 `NULL` 처리됨
  - `NULL`만 있는 경우는 없음
- 요구사항: 잡은 물고기 중 **가장 큰 물고기 길이**를 구하고, 뒤에 `'cm'` 단위를 붙여 출력
- 출력 컬럼명: `MAX_LENGTH`
- 출력 예시: `50.00cm`

## 가장 큰 물고기의 길이
SELECT CONCAT(MAX(LENGTH), 'cm') AS MAX_LENGTH   --'cm'를 붙여서 출력해야 하므로 CONCAT()을 쓰는 것이 핵심
FROM FISH_INFO;
