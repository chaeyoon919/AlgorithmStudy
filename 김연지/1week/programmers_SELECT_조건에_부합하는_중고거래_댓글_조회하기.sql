1.used_goods_board와 used_goods_reply를 board_id 기준으로 join
2.where : 2022-10월에 작성된 게시글 분류
3.created_date 포맷을 맞추기 위해 date_format 사용 (*대문자 Y를 사용하면 2022까지 표기, 소문자 사용시 22만 표기)
4.** order by에서 select 절에 사용한 별칭 created_date를 사용하기 **
   그냥 테이블의 r.created_date를 사용하면 잘못 정렬이 된다..

select
    b.title,
    b.board_id,
    r.reply_id,
    r.writer_id,
    r.contents,
    date_format(r.created_date, '%Y-%m-%d') as created_date
from
    used_goods_board b
join
    used_goods_reply r on b.board_id = r.board_id
where
    b.created_date >= '2022-10-01' and b.created_date < '2022-11-01'
order by
    created_date, b.title;