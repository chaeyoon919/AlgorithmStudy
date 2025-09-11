1. fish_type를 기준으로 join
2. fish_name_info에 있는 fish_name이 bass, snapper인 경우만 고르기(where절)
3. 전체 행 count


select count(*) as fish_count
from
    fish_info f
join
    fish_name_info n on f.fish_type = n.fish_type
where n.fish_name in ('bass','snapper');