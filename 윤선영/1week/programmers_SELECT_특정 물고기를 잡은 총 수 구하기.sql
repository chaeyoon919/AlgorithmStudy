-- 문제: 특정 물고기를 잡은 총 수 구하기
-- FISH_INFO : 물고기 개별 정보
-- FISH_NAME_INFO : 물고기 이름과 종류 번호 매핑
-- 물고기 이른이 'BASS' 또는 'SNAPPER'인 것만 필터링

SELECT COUNT(*) AS FISH_COUNT
FROM FISH_INFO FI
JOIN FISH_NAME_INFO FN
  ON FI.FISH_TYPE = FN.FISH_TYPE
WHERE FN.FISH_NAME IN ('BASS', 'SNAPPER');
