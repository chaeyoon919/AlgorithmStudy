## 문제 설명
# 첫째 줄에 문자열의 개수 : N, M
# 다음 N개의 줄: 집합 S에 포함되어 있는 문자열
# 다음 M개의 줄: 검사해야 하는 문자열

# 총 N개의 문자열로 이루어진 집합 S
# 입력으로 주어지는 M개의 문자열 중에서 집합 S에 포함되어 있는 것이 총 몇 개인지


## 접근 방법
# 1. 첫번째에 n개의 문자열이 들어옴 => 집합 S
# 2. 그 다음 입력되는 문자열(개수: m)이 S 안에 포함하는지
# 3. 포함되면 포함 개수 += 1 

## 문제 풀이
n, m = map(int, input().split())

word_set = []
for i in range(n):
	word_set.append(input())

find_cnt = 0
for j in range(m):
	target = input()
	if target in word_set:
		find_cnt += 1

print(find_cnt)		






