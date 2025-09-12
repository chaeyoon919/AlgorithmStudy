a, b = map(int, input().split())
c = set()
cnt = 0

# 집합에 문자열 N개 저장
for _ in range(a):
    c.add(input())

# 이후 M개 문자열 입력받으면서 집합에 존재하는지 확인
for _ in range(b):
    if input() in c:
        cnt += 1

print(cnt)
