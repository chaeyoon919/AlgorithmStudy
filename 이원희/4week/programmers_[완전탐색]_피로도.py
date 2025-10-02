from itertools import permutations

def solution(k, dungeons):
    orders = list(permutations(dungeons))
    answer = 0
    
    for order in orders:
        can_clear = 0
        now = k
        for dungeon in order:
            if now >= dungeon[0]:
                can_clear += 1
                now -= dungeon[1]
                
        if can_clear > answer:
            answer = can_clear
            
    return answer
