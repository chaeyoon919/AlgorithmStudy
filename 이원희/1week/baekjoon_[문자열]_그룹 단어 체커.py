"""
1. queue를 사용해서 접근. 앞 문자부터 순차적 접근
2. set() 을 선언하고, 처음 보는 문자라면 추가
3. 이전 문자와 다른데 set안에 이미 존재하는 문자라면 그룹 단어 X
"""

from collections import deque

n = int(input())
count = n

for _ in range(n):
    
    word = input()
    group = set()
    
    q = deque(word)
    c1 = q.popleft()
    group.add(c1)
    
    while q:
        
        c2 = q.popleft()
        
        if c1 != c2:
            if c2 in group:
                count -= 1
                break
            
            else:
                group.add(c2)
        
        c1 = c2
            

    
print(count)    
