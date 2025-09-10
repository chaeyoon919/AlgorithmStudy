"""
'level', 'kayak' 등 대칭인 문자를 palindrome (회문) 이라고 부름.
'summuus' 와 같이 한 문자를 제거함으로 써 palindrome이 된다면 pseudo palinedrom (유사회문).
palindrome / pseudo palinedrom / else 의 경우를 0 / 1 / 2 로 출력
투포인터 방식으로 접근
"""

# 끝까지 모두 일치한다면 회문, 중간에 다른 부분이 있다면 회문 X
def is_palindrome(word, start, end):
    
    while start < end:
        if word[start] != word[end]:
            return False
        
        start += 1
        end -= 1
        
    return True



def solution(word):
    """
    두 포인터로 양끝을 비교하다가 '첫 불일치 지점'에서
    왼쪽 글자 제거 / 오른쪽 글자 제거 두 경우만 검사.
    """
  
    start = 0
    end = len(word) - 1
    
    # 중간에 대칭이 아닌 문자가 있다면 그 부분까지 start와 end의 범위 좁히기.
    while start < end and word[start] == word[end]:
        start += 1
        end -= 1
   
    # 모두 대칭이라면 회문, 0 출력
    if start >= end:
        return 0
    
    # 첫 불일치 후에 왼쪽/오른쪽 하나의 문자를 제거하는 경우를 확인
    # 둘 중 하나라도 회문이면 유사회문
    if is_palindrome(word, start + 1, end) or is_palindrome(word, start, end - 1):
        return 1
    
    # 둘 다 아니라면 회문 X
    return 2

#--------------------------------------------------

T = int(input())

for _ in range(T):
    
    word = input()
    print(solution(word))
