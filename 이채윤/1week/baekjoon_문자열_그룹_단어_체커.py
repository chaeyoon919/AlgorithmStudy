## 문제 접근
# 그룹 단어: 단어 내 각 문자가 연속해서 나타나는 경우
#	# e.g., ccazzzzbb -> c, a, z, b가 연속이므로 그룹 단어
# 	#e.g., aabbbccb -> b가 떨어졌기에 그룹 단어 아님
# 1. 단어의 각 문자를 반복해서 다음 문자와 비교하기
# 2. 문자가 다음문자와 같으면: pass
# 3. 문자가 다음문자와 다르고 & 해당 문자 뒤에 포함되어 있는 경우, 그룹단어가 아니기에 단어 개수에서 1 차감


# 단어 개수 인풋받기
cnt = int(input())

# 단어 수만큼 반복
for i in range(cnt):
	# 단어 인풋받기
	word = input()
	# 단어 내에서 반복
	for j in range(len(word)-1):
		if word[j] == word[j+1]:
			pass
		elif word[j] in word[j+1:]:
			cnt-=1
			break

print(cnt)

