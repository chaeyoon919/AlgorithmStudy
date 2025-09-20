### 문제 요약
- 테이블: `tips`
- 요구사항:
  - 요일(`day`), 시간대(`time`)별로 그룹화
  - 각 그룹의 평균 팁(`avg_tip`)과 평균 일행 수(`avg_size`)를 계산
  - 평균값은 **소수 둘째 자리까지 반올림**
- 출력 컬럼: `day`, `time`, `avg_tip`, `avg_size`
- 정렬 조건: `day`, `time` 오름차순 (알파벳 순서)

## 문제 풀이
## (1) 각 요일/시간대별 (2) 평균 팁, 평균 일행 수   -- (1) group by day, time (2) avg(tip), avg(size)
## 평균값은 **소수 둘째 자리까지 반올림**   -- round(avg(*))
## day, time 오름차순 (알파벳 순서)   -- order by 1,2 또는 order by day asc, time asc
SELECT
  day, time, round(avg(tip),2) as avg_tip, round(avg(size),2) as avg_size 
FROM tips
GROUP BY day, time
ORDER BY 1,2;
