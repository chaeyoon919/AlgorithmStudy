# [풀이]
SELECT measured_at AS good_day
FROM measurements
WHERE 1=1
AND measured_at BETWEEN "2022-12-01" AND "2022-12-31"
AND pm2_5 <= 9
ORDER BY measured_at ASC
;

# [개념 정리]
# - BETWEEN: 
