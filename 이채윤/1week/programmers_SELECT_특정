## 문제 접근
-- 핵심 조건: 물고기 이름이 "BASS", "SNAPPER"인 경우, 물고기의 개수
-- 테이블 관계 파악
-- 1. fish_info: 물고기 개체별 정보
-- 2. fish_name_info: 물고기 종류 코드와 이름 매핑 테이블

## 최종 쿼리
-- 조건에 맞는 행 개수 세기
SELECT COUNT(*) AS FISH_COUNT
FROM fish_info fi
-- 두 테이블 연결
-- fish_info는 fish_type 코드만 가지고 있으므로, 실제 이름은 fish_name_info와 조인해야 함
JOIN fish_name_info fni ON fi.fish_type = fni.fish_type
-- 필요한 물고기만 필터링
WHERE fish_name = 'BASS' OR fish_name = 'SNAPPER'
