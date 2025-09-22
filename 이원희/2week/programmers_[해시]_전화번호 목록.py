def solution(phone_book):
    phone_nums = {}
    for num in phone_book:
        phone_nums[num] = True
    
    for num in phone_book:
        head = ''
        for h in num:
            head += h
            if head == num:
                continue
            else:
                if head in phone_nums:
                    return False
                   
    
    return True
