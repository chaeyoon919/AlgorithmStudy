import sys

n = int(sys.stdin.readline().rstrip())
lines = []
length = 0

for _ in range(n):
    lines.append(tuple(map(int, sys.stdin.readline().rstrip().split())))

lines.sort()
start, end = lines[0][0], lines[0][1]

for line in lines[1:]:
    
    if start <= line[0] and line[1] <= end:
        continue
    
    elif start <= line[0] <= end and end < line[1]:
        end = line[1]
        
    elif end < line[0]:
        length += (end - start)
        start = line[0]
        end = line[1]

length += (end-start)
print(length)
    
