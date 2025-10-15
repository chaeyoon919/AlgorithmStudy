N, C = map(int, input().split())

home = sorted([int(input()) for _ in range(N)])
start = 1
end = home[-1] - home[0]
ans = 0

while start <= end:
    mid = (start + end) // 2
    cnt = 1
    last = home[0]
    
    for i in range(1,N):
        if last + mid <= home[i]:
            cnt += 1
            last = home[i]
            
    if cnt >= C:
        ans = mid
        start = mid + 1
        
    else:
        end = mid - 1
        
print(ans)
        
