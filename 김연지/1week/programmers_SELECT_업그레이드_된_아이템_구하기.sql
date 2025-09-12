1. PARENT_ITEM_ID가 희귀도가 RARE인 ITEM_ID(0, 1, 3, 4) 중에서 0, 1에 있으므로 해당 ITEM_ID인 (1, 2, 3, 4) SELECT됨
2. 이 (1, 2, 3, 4)의 정보 뽑기 -> 얘네는 업그레이드가 된 아이템들이니까!


SELECT  
    T.ITEM_ID,
    I.ITEM_NAME,
    I.RARITY
FROM
    ITEM_TREE T
JOIN ITEM_INFO I ON T.ITEM_ID = I. ITEM_ID
WHERE PARENT_ITEM_ID IN (SELECT ITEM_ID
                         FROM   ITEM_INFO
                         WHERE RARITY = 'RARE')
ORDER BY
    T.ITEM_ID DESC;
    