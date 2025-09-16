1. BIT 연산으로 풀기
2. SKILL_CODE에 python의 포함여부를 알려면 (개발자의 스킬코드 & Python 코드)를 해서 Python 스킬코드가 연산 결과로 나오면 해당 스킬을 보유했다는 뜻.
3. 파이썬 -> 10진수로 4라면 2진수로
4. WHERE 조건절에 스칼라 서브쿼리를 넣어 사용


SELECT ID, EMAIL, FIRST_NAME, LAST_NAME
FROM
    DEVELOPERS
WHERE
    SKILL_CODE & (SELECT CODE FROM SKILLCODES WHERE NAME = 'Python')
OR  SKILL_CODE & (SELECT CODE FROM SKILLCODES WHERE NAME = 'C#')
ORDER BY
    ID;
    