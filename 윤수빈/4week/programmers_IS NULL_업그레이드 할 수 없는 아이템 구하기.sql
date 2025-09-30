## 더 이상 업그레이드할 수 없는 아이템 구하기
-- 조건: ITEM_TREE 테이블에서 parent_item_id로 등장하지 않는 item_id를 찾기

SELECT item_id, item_name, rarity
FROM item_info I
WHERE NOT EXISTS (
    -- 해당 아이템이 parent_item_id로 등장한다면 -> **업그레이드 가능한 아이템**이므로 NOT EXISTS로 업그레이드 불가능한 아이템만 남김
    SELECT T.parent_item_id
    FROM item_tree T
    WHERE T.parent_item_id = I.item_id
)
ORDER BY item_id DESC;
