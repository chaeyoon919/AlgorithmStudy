"""
1. deque를 사용한 접근
2. 패턴의 앞 뒤, input word를 덱에 삽입
3. 패턴의 앞, input word의 앞 비교 / 패턴의 뒤, input word의 뒤 한 글자씩 비교
4. 틀린게 나오면 'NE' 없으면 'DA'
"""

from collections import deque


def check(q, q_f, q_b):
    
    while q_f and q_b:
        if q_f.popleft() != q.popleft() or q_b.pop() != q.pop():
            return 'NE'
        
    while q_f:
        if q_f.popleft() != q.popleft():
            return 'NE'
    
    while q_b:
        if q_b.pop() != q.pop():
            return 'NE'
        
    return 'DA'

N = int(input())
pt = input()
front_pt, back_pt = pt.split('*')[0], pt.split('*')[1]

for _ in range(N):
    
    word = input()
    if len(word) < len(front_pt) + len(back_pt):
        print('NE')
        
    else:
        q = deque(word)
        q_f = deque(front_pt)
        q_b = deque(back_pt)
        
        ans = check(q, q_f, q_b)
        
        print(ans)
#----------------------------------------------------------------------
"""
1. 문자열 전용함수(startswith, endswith)를 사용한 접근
2. input word의 앞과 패턴의 앞 전체 비교 / input word의 뒤, 패턴의 뒤 전체 비교
3. 틀린게 나오면 'NE' 없으면 'DA'

-- 시간 복잡도 측면에서 덱이 빠를 것이라 생각했으나, startswith, endswith은 단순 슬라이싱과 다름.
-- 슬라이싱은 실제로 문자열 생성, 하지만 startswith, endswith는 생성이 아닌 단순 비교.
"""


N = int(input())
pt = input()
front_pt, back_pt = pt.split('*')

for _ in range(N):
    
    word = input()
    if len(word) < len(front_pt) + len(back_pt):
        print('NE')
        
    else:
        if word.startswith(front_pt) and word.endswith(back_pt):
            print('DA')
        else:
            print('NE')
    
