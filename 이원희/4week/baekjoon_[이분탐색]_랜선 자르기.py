K, N = map(int, input().split())

lans = [int(input()) for _ in range(K)]

start = 1
end = max(lans)
mid = (start + end) // 2

while start <= end:
    mid = (start + end) // 2
    cnt = sum(lan // mid for lan in lans)
    
    if cnt >= N:
        ans = mid
        start = mid + 1
        
    else:
        end = mid - 1
        
print(ans)
