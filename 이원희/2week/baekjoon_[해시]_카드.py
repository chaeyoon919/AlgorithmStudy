n = int(input())
dummy = {}
max_key = []
max_cnt = 0

for _ in range(n):
    card = int(input())
    dummy[card] = dummy.get(card, 0) + 1

for key, value in dummy.items():
    if value > max_cnt :
        max_key = [key]
        max_cnt = value
        
    elif value == max_cnt:
        max_key.append(key)
        
print(sorted(max_key)[0])
