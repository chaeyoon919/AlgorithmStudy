n = int(input())


def solution(n):
    stack = []
    pp = []
    add = 1
    for _ in range(n):

        num = int(input())

        while num >= add:
            stack.append(add)
            add += 1
            pp.append('+')

        c = stack.pop()
        if c == num:
            pp.append('-')

        else:
            return ['NO']

    return pp

print(*solution(n), sep='\n')
