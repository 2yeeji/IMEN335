select attraction_name, cnt,
	rank() over (order by cnt desc) as rnk
from
	(select A.attraction_name
		,count(*) cnt
	from plan P 
		inner join ticket T
		on P.ticket_id=T.ticket_id
		inner join attraction A
		on P.attraction_id=A.attraction_id
	where A.attraction_type='ride'
	and right(ticket_code,1)=1
	group by A.attraction_name) as A
;