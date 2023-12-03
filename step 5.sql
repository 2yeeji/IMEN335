-- 이용가능한 놀이기구
select A.attraction_name
from attraction A
	inner join ticket T
	on T.height between A.height_from and A.height_to
	and T.age between A.age_from and A.age_to
	inner join cart C 
	on C.cart_id=T.cart_id
	and dayofweek(C.date)<>A.inspectiond_day
where T.ticket_id=@ticketid;

-- 놀이기구별 대기시간

SELECT A.attraction_name, if(
	dayofweek(curdate())<>A.inspectiond_day,
	concat(round(W.waiting/A.max_available/A.opnumph*60),'min'),
	'점검일') as 'waiting_time'
FROM attraction_waiting W
	inner join attraction A
	on W.attraction_id=A.attraction_id;

-- 이용가능한 놀이기구 별 대기시간

select P.attraction_name, waiting_time from (
	select A.attraction_name
	from attraction A
		inner join ticket T
		on T.height between A.height_from and A.height_to
		and T.age between A.age_from and A.age_to
		inner join cart C 
		on C.cart_id=T.cart_id
		and dayofweek(C.date)<>A.inspectiond_day
	where T.ticket_id=@ticketid
)P
inner join
(
	SELECT A.attraction_name, if(
		dayofweek(curdate())<>A.inspectiond_day,
		concat(round(W.waiting/A.max_available/A.opnumph*60),'min'),
		'점검일') as 'waiting_time'
	FROM attraction_waiting W
		inner join attraction A
		on W.attraction_id=A.attraction_id
)Q
on P.attraction_name=Q.attraction_name;