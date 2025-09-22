a, b = map(int, input().split())
c = set()
d = set()
for i in range(a) :
    c.add(input())
for j in range(b) :
    d.add(input())
    
e = sorted(c&d)
print(len(e))
print(*e, sep ='\n')
