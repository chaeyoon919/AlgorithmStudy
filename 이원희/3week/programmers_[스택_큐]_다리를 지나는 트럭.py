from collections import deque

def solution(bridge_length, weight, truck_weights):
    
    answer = 0
    q0_wait = deque(truck_weights)
    q1_ing = deque([0 for _ in range(bridge_length)])
    q0_weight = sum(truck_weights)
    q1_weight = 0
    q2_weight = 0
    
    while q2_weight < q0_weight:
        if q0_wait:
            c = q0_wait.popleft()
            d = q1_ing.popleft()
            q1_weight -= d
            q2_weight += d
            if c + q1_weight <= weight:
                q1_ing.append(c)
                q1_weight += c
                answer += 1
                
            else:
                q1_ing.append(0)
                q0_wait.appendleft(c)
                answer += 1
                
        else:
            if q1_weight != 0:
                d = q1_ing.popleft()
                q2_weight += d
                q1_ing.append(0)
                answer += 1
    
    
    
    return answer
